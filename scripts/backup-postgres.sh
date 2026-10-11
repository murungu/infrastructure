#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/backup-common.sh
source "${SCRIPT_DIR}/lib/backup-common.sh"

require_command docker
require_command python3

POSTGRES_CONTAINER="${POSTGRES_CONTAINER:-db-infra-postgres}"
DATABASE_NAME="$(resolve_database_name)"
BACKUP_DIR="${BACKUP_DIR:-${BACKUP_REPO_ROOT}/backups/postgres}"

validate_database_name "${DATABASE_NAME}"
require_running_container "${POSTGRES_CONTAINER}"

if ! docker exec "${POSTGRES_CONTAINER}" sh -c \
  'exec psql -X -At -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$1" -c "SELECT 1"' \
  sh "${DATABASE_NAME}" >/dev/null; then
  printf 'Cannot connect to PostgreSQL database %s in container %s.\n' \
    "${DATABASE_NAME}" "${POSTGRES_CONTAINER}" >&2
  exit 1
fi

mkdir -p "${BACKUP_DIR}"
chmod 700 "${BACKUP_DIR}"

created_at="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
timestamp="$(date -u +'%Y%m%dT%H%M%SZ')"
base_name="${DATABASE_NAME}_${timestamp}"
backup_path="${BACKUP_DIR}/${base_name}.dump"
partial_path="${backup_path}.partial"
manifest_path="${BACKUP_DIR}/${base_name}.manifest.json"
checksum_path="${BACKUP_DIR}/${base_name}.sha256"
metrics_path="$(mktemp "${TMPDIR:-/tmp}/nopcommerce-backup-metrics.XXXXXX")"

cleanup() {
  rm -f "${partial_path}" "${metrics_path}"
}
trap cleanup EXIT

printf 'Creating PostgreSQL backup\n'
printf '  Database:  %s\n' "${DATABASE_NAME}"
printf '  Container: %s\n' "${POSTGRES_CONTAINER}"
printf '  Output:    %s\n' "${backup_path}"

docker exec "${POSTGRES_CONTAINER}" sh -c \
  'exec pg_dump -U "$POSTGRES_USER" --format=custom --compress=6 --no-owner --no-acl "$1"' \
  sh "${DATABASE_NAME}" >"${partial_path}"

if [[ ! -s "${partial_path}" ]]; then
  printf 'Backup archive is empty.\n' >&2
  exit 1
fi

# A custom-format archive that pg_restore cannot list is not accepted as a backup.
docker exec -i "${POSTGRES_CONTAINER}" sh -c \
  'exec pg_restore --list >/dev/null' <"${partial_path}"

mv "${partial_path}" "${backup_path}"
chmod 600 "${backup_path}"

checksum="$(sha256_file "${backup_path}")"
printf '%s  %s\n' "${checksum}" "$(basename "${backup_path}")" >"${checksum_path}"
chmod 600 "${checksum_path}"

cat <<'SQL' | docker exec -i "${POSTGRES_CONTAINER}" sh -c \
  'exec psql -X -At -F "=" -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$1" -f -' \
  sh "${DATABASE_NAME}" >"${metrics_path}"
SELECT 'table_count', count(*) FROM information_schema.tables
 WHERE table_schema='public' AND table_type='BASE TABLE';
SELECT 'products', count(*) FROM "Product" WHERE NOT "Deleted";
SELECT 'customers', count(*) FROM "Customer" WHERE NOT "Deleted";
SELECT 'orders', count(*) FROM "Order" WHERE NOT "Deleted";
SELECT 'pictures', count(*) FROM "Picture";
SELECT 'picture_binaries', count(*) FROM "PictureBinary";
SELECT 'settings', count(*) FROM "Setting";
SELECT 'migration_version', "Version" FROM "MigrationVersionInfo" ORDER BY "Version" DESC LIMIT 1;
SQL

postgres_version="$(docker exec "${POSTGRES_CONTAINER}" postgres --version)"
postgres_image="$(docker inspect --format '{{.Config.Image}}' "${POSTGRES_CONTAINER}")"
archive_bytes="$(wc -c <"${backup_path}" | tr -d ' ')"

python3 - \
  "${manifest_path}" \
  "$(basename "${backup_path}")" \
  "${DATABASE_NAME}" \
  "${created_at}" \
  "${checksum}" \
  "${archive_bytes}" \
  "${postgres_version}" \
  "${postgres_image}" \
  "${metrics_path}" <<'PY'
import json
import pathlib
import sys

(
    manifest_path,
    archive_name,
    database,
    created_at,
    checksum,
    archive_bytes,
    postgres_version,
    postgres_image,
    metrics_path,
) = sys.argv[1:]

metrics = {}
for line in pathlib.Path(metrics_path).read_text().splitlines():
    if not line or "=" not in line:
        continue
    key, value = line.split("=", 1)
    metrics[key] = int(value) if value.isdigit() else value

manifest = {
    "format_version": 1,
    "archive": archive_name,
    "database": database,
    "created_at_utc": created_at,
    "sha256": checksum,
    "archive_bytes": int(archive_bytes),
    "postgres_version": postgres_version,
    "postgres_image": postgres_image,
    "metrics": metrics,
}

pathlib.Path(manifest_path).write_text(json.dumps(manifest, indent=2) + "\n")
PY
chmod 600 "${manifest_path}"
printf '%s\n' "$(basename "${backup_path}")" >"${BACKUP_DIR}/LATEST"
chmod 600 "${BACKUP_DIR}/LATEST"

printf 'Backup completed successfully.\n'
printf '  Archive:  %s\n' "${backup_path}"
printf '  Checksum: %s\n' "${checksum_path}"
printf '  Manifest: %s\n' "${manifest_path}"
