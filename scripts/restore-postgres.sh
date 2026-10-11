#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/backup-common.sh
source "${SCRIPT_DIR}/lib/backup-common.sh"

usage() {
  cat <<'EOF'
Usage: scripts/restore-postgres.sh BACKUP_FILE TARGET_DATABASE

Restores a backup into a database in the existing PostgreSQL container.
The safe default requires a separate target. If the target already exists, set
REPLACE_EXISTING=1 to replace it.

Disaster recovery on a new machine may target the configured active database,
but only while nopCommerce is stopped and only when
ALLOW_ACTIVE_DATABASE_RESTORE exactly matches the target database name.

Examples:
  scripts/restore-postgres.sh backups/postgres/nopcommerce_local_....dump nopcommerce_recovery
  REPLACE_EXISTING=1 scripts/restore-postgres.sh backups/postgres/example.dump nopcommerce_recovery
  ALLOW_ACTIVE_DATABASE_RESTORE=nopcommerce_local REPLACE_EXISTING=1 \\
    scripts/restore-postgres.sh backups/postgres/example.dump nopcommerce_local
EOF
}

if [[ $# -ne 2 ]]; then
  usage >&2
  exit 2
fi

require_command docker

POSTGRES_CONTAINER="${POSTGRES_CONTAINER:-db-infra-postgres}"
ACTIVE_DATABASE="$(resolve_database_name)"
BACKUP_PATH="$(resolve_backup_path "$1")"
TARGET_DATABASE="$2"

validate_database_name "${ACTIVE_DATABASE}"
validate_database_name "${TARGET_DATABASE}"
require_running_container "${POSTGRES_CONTAINER}"

if [[ ! -f "${BACKUP_PATH}" ]]; then
  printf 'Backup archive not found: %s\n' "${BACKUP_PATH}" >&2
  exit 1
fi

if [[ "${TARGET_DATABASE}" == "${ACTIVE_DATABASE}" ]]; then
  if [[ "${ALLOW_ACTIVE_DATABASE_RESTORE:-}" != "${TARGET_DATABASE}" ]]; then
    printf 'Refusing to restore over the active database: %s\n' "${ACTIVE_DATABASE}" >&2
    printf 'Restore into a separate database for normal recovery.\n' >&2
    printf 'On a new machine, stop nopCommerce and set ' >&2
    printf 'ALLOW_ACTIVE_DATABASE_RESTORE=%s.\n' "${TARGET_DATABASE}" >&2
    exit 1
  fi

  if [[ "$(docker inspect --format '{{.State.Running}}' db-infra-nopcommerce 2>/dev/null || true)" == "true" ]]; then
    printf 'Refusing active-database restore while db-infra-nopcommerce is running.\n' >&2
    printf 'Stop the application container before disaster recovery.\n' >&2
    exit 1
  fi
fi

verify_backup_checksum "${BACKUP_PATH}"
docker exec -i "${POSTGRES_CONTAINER}" sh -c \
  'exec pg_restore --list >/dev/null' <"${BACKUP_PATH}"

exists="$(docker exec "${POSTGRES_CONTAINER}" sh -c \
  'exec psql -X -At -U "$POSTGRES_USER" -d postgres -c "SELECT 1 FROM pg_database WHERE datname = '\''$1'\''"' \
  sh "${TARGET_DATABASE}")"

if [[ "${exists}" == "1" ]]; then
  if [[ "${REPLACE_EXISTING:-0}" != "1" ]]; then
    printf 'Target database already exists: %s\n' "${TARGET_DATABASE}" >&2
    printf 'Set REPLACE_EXISTING=1 to replace that non-production target.\n' >&2
    exit 1
  fi

  printf 'Dropping existing target database: %s\n' "${TARGET_DATABASE}"
  docker exec "${POSTGRES_CONTAINER}" sh -c \
    'exec dropdb --force -U "$POSTGRES_USER" "$1"' sh "${TARGET_DATABASE}"
fi

printf 'Creating target database: %s\n' "${TARGET_DATABASE}"
docker exec "${POSTGRES_CONTAINER}" sh -c \
  'exec createdb -U "$POSTGRES_USER" -O "$POSTGRES_USER" -T template0 "$1"' \
  sh "${TARGET_DATABASE}"

printf 'Restoring %s into %s\n' "${BACKUP_PATH}" "${TARGET_DATABASE}"
if ! docker exec -i "${POSTGRES_CONTAINER}" sh -c \
  'exec pg_restore -U "$POSTGRES_USER" -d "$1" --exit-on-error --no-owner --no-privileges' \
  sh "${TARGET_DATABASE}" <"${BACKUP_PATH}"; then
  printf 'Restore failed. The incomplete target database was left in place for diagnosis: %s\n' \
    "${TARGET_DATABASE}" >&2
  exit 1
fi

printf 'Running restored database checks\n'
cat <<'SQL' | docker exec -i "${POSTGRES_CONTAINER}" sh -c \
  'exec psql -X -At -F "=" -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$1" -f -' \
  sh "${TARGET_DATABASE}"
SELECT 'table_count', count(*) FROM information_schema.tables
 WHERE table_schema='public' AND table_type='BASE TABLE';
SELECT 'products', count(*) FROM "Product" WHERE NOT "Deleted";
SELECT 'customers', count(*) FROM "Customer" WHERE NOT "Deleted";
SELECT 'orders', count(*) FROM "Order" WHERE NOT "Deleted";
SELECT 'pictures', count(*) FROM "Picture";
SELECT 'picture_binaries', count(*) FROM "PictureBinary";
SQL

printf 'Restore completed successfully.\n'
printf '  Source: %s\n' "${BACKUP_PATH}"
printf '  Target: %s\n' "${TARGET_DATABASE}"
