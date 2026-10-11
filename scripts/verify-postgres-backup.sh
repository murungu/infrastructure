#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/backup-common.sh
source "${SCRIPT_DIR}/lib/backup-common.sh"

require_command docker
require_command python3
require_command curl

BACKUP_PATH="$(resolve_backup_path "${1:-}")"
VERIFY_APP="${VERIFY_APP:-1}"
VERIFY_TIMEOUT="${VERIFY_TIMEOUT:-90}"
APP_VERIFY_TIMEOUT="${APP_VERIFY_TIMEOUT:-180}"

if [[ ! -f "${BACKUP_PATH}" ]]; then
  printf 'Backup archive not found: %s\n' "${BACKUP_PATH}" >&2
  exit 1
fi

verify_backup_checksum "${BACKUP_PATH}"

run_id="$(date -u +'%Y%m%d%H%M%S')-$$"
network="nopcommerce-backup-verify-${run_id}"
postgres_container="nopcommerce-backup-postgres-${run_id}"
app_container="nopcommerce-backup-app-${run_id}"
verify_user="backup_verify"
verify_database="backup_verify"
verify_password="backup-verify-${run_id}"
metrics_path="$(mktemp "${TMPDIR:-/tmp}/nopcommerce-verify-metrics.XXXXXX")"
response_path="$(mktemp "${TMPDIR:-/tmp}/nopcommerce-verify-response.XXXXXX")"

cleanup() {
  local exit_code=$?
  rm -f "${metrics_path}" "${response_path}"

  if [[ "${KEEP_VERIFY_ENV:-0}" == "1" && ${exit_code} -ne 0 ]]; then
    printf 'Verification environment retained for diagnosis:\n' >&2
    printf '  PostgreSQL: %s\n  Application: %s\n  Network: %s\n' \
      "${postgres_container}" "${app_container}" "${network}" >&2
    return
  fi

  docker rm -f "${app_container}" >/dev/null 2>&1 || true
  docker rm -f "${postgres_container}" >/dev/null 2>&1 || true
  docker network rm "${network}" >/dev/null 2>&1 || true
}
trap cleanup EXIT

printf 'Verifying backup in an isolated environment\n'
printf '  Archive: %s\n' "${BACKUP_PATH}"

docker network create "${network}" >/dev/null

docker run -d \
  --name "${postgres_container}" \
  --network "${network}" \
  --tmpfs /var/lib/postgresql/data:rw,nosuid,size=512m \
  -e POSTGRES_USER="${verify_user}" \
  -e POSTGRES_PASSWORD="${verify_password}" \
  -e POSTGRES_DB="${verify_database}" \
  postgres:16-alpine >/dev/null

printf 'Waiting for isolated PostgreSQL'
ready=0
for ((attempt = 1; attempt <= VERIFY_TIMEOUT; attempt++)); do
  if docker exec "${postgres_container}" pg_isready \
    -U "${verify_user}" -d "${verify_database}" >/dev/null 2>&1; then
    ready=1
    break
  fi
  printf '.'
  sleep 1
done
printf '\n'

if [[ "${ready}" != "1" ]]; then
  printf 'Isolated PostgreSQL did not become ready within %s seconds.\n' "${VERIFY_TIMEOUT}" >&2
  docker logs --tail 50 "${postgres_container}" >&2 || true
  exit 1
fi

printf 'Restoring archive into isolated PostgreSQL\n'
docker exec -i "${postgres_container}" pg_restore \
  -U "${verify_user}" \
  -d "${verify_database}" \
  --exit-on-error \
  --no-owner \
  --no-privileges <"${BACKUP_PATH}"

cat <<'SQL' | docker exec -i "${postgres_container}" psql \
  -X -At -F "=" -v ON_ERROR_STOP=1 \
  -U "${verify_user}" -d "${verify_database}" -f - >"${metrics_path}"
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

python3 - "${metrics_path}" "$(manifest_path_for "${BACKUP_PATH}")" <<'PY'
import json
import pathlib
import sys

metrics_path = pathlib.Path(sys.argv[1])
manifest_path = pathlib.Path(sys.argv[2])

actual = {}
for line in metrics_path.read_text().splitlines():
    if not line or "=" not in line:
        continue
    key, value = line.split("=", 1)
    actual[key] = int(value) if value.isdigit() else value

required_minimums = {
    "table_count": 100,
    "products": 1,
    "settings": 1,
}
for key, minimum in required_minimums.items():
    value = actual.get(key)
    if not isinstance(value, int) or value < minimum:
        raise SystemExit(f"Restored database check failed: {key}={value!r}, expected at least {minimum}")

if actual.get("pictures") != actual.get("picture_binaries"):
    raise SystemExit(
        "Restored database check failed: Picture and PictureBinary counts differ "
        f"({actual.get('pictures')} != {actual.get('picture_binaries')})"
    )

print("Restored database metrics:")
for key in sorted(actual):
    print(f"  {key}: {actual[key]}")

if manifest_path.is_file():
    expected = json.loads(manifest_path.read_text()).get("metrics", {})
    print("Source manifest comparison:")
    for key in sorted(set(expected) | set(actual)):
        marker = "OK" if expected.get(key) == actual.get(key) else "DIFF"
        print(f"  [{marker}] {key}: source={expected.get(key)!r}, restored={actual.get(key)!r}")
PY

if [[ "${VERIFY_APP}" == "1" ]]; then
  app_image="${NOPCOMMERCE_IMAGE:-}"
  if [[ -z "${app_image}" ]]; then
    app_image="$(docker inspect --format '{{.Config.Image}}' db-infra-nopcommerce 2>/dev/null || true)"
  fi
  app_image="${app_image:-infrastructure-nopcommerce}"

  if ! docker image inspect "${app_image}" >/dev/null 2>&1; then
    printf 'nopCommerce image is unavailable for application verification: %s\n' "${app_image}" >&2
    printf 'Set VERIFY_APP=0 to perform database-only verification.\n' >&2
    exit 1
  fi

  connection_string="Host=${postgres_container};Port=5432;Database=${verify_database};Username=${verify_user};Password=${verify_password};Pooling=true;Trust Server Certificate=true;"

  printf 'Starting isolated nopCommerce container from %s\n' "${app_image}"
  docker run -d \
    --name "${app_container}" \
    --network "${network}" \
    -p 127.0.0.1::80 \
    -e ASPNETCORE_ENVIRONMENT=Production \
    -e ConnectionStrings__ConnectionString="${connection_string}" \
    -e ConnectionStrings__DataProvider=postgresql \
    "${app_image}" >/dev/null

  host_port="$(docker port "${app_container}" 80/tcp | awk -F: 'NR==1 {print $NF}')"
  if [[ -z "${host_port}" ]]; then
    printf 'Could not determine the temporary nopCommerce port.\n' >&2
    exit 1
  fi

  printf 'Waiting for isolated nopCommerce'
  http_status=""
  for ((attempt = 1; attempt <= APP_VERIFY_TIMEOUT; attempt++)); do
    http_status="$(curl -sS -o "${response_path}" -w '%{http_code}' \
      --max-time 5 "http://127.0.0.1:${host_port}/" 2>/dev/null || true)"
    if [[ "${http_status}" == "200" ]]; then
      break
    fi

    if [[ "$(docker inspect --format '{{.State.Running}}' "${app_container}" 2>/dev/null || true)" != "true" ]]; then
      break
    fi

    printf '.'
    sleep 1
  done
  printf '\n'

  if [[ "${http_status}" != "200" ]]; then
    printf 'Application smoke test failed with HTTP status %s.\n' "${http_status:-unavailable}" >&2
    docker logs --tail 80 "${app_container}" >&2 || true
    exit 1
  fi

  if grep -Eqi 'nopCommerce installation|install nopCommerce|admin email' "${response_path}"; then
    printf 'Application smoke test reached the installation wizard instead of the restored store.\n' >&2
    exit 1
  fi

  printf 'Application smoke test passed: HTTP 200 and no installation wizard.\n'
else
  printf 'Application smoke test skipped because VERIFY_APP=%s.\n' "${VERIFY_APP}"
fi

printf 'Backup verification completed successfully.\n'
