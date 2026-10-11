#!/usr/bin/env bash

# Shared helpers for the PostgreSQL backup and restore scripts.
# This file is sourced; callers must enable their preferred shell options.

BACKUP_REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BACKUP_ENV_FILE="${ENV_FILE:-${BACKUP_REPO_ROOT}/.env}"

read_env_value() {
  local key="$1"
  local value=""

  if [[ -f "${BACKUP_ENV_FILE}" ]]; then
    value="$(awk -F= -v wanted="${key}" '
      $1 == wanted {
        sub(/^[^=]*=/, "")
        sub(/\r$/, "")
        print
        exit
      }
    ' "${BACKUP_ENV_FILE}")"
  fi

  if [[ "${value}" == \"*\" && "${value}" == *\" ]]; then
    value="${value:1:${#value}-2}"
  elif [[ "${value}" == \'*\' && "${value}" == *\' ]]; then
    value="${value:1:${#value}-2}"
  fi

  printf '%s' "${value}"
}

resolve_database_name() {
  local configured="${DATABASE_NAME:-${NOPCOMMERCE_DB:-}}"

  if [[ -z "${configured}" ]]; then
    configured="$(read_env_value NOPCOMMERCE_DB)"
  fi

  printf '%s' "${configured:-nopcommerce_local}"
}

validate_database_name() {
  local database="$1"

  if [[ ! "${database}" =~ ^[A-Za-z][A-Za-z0-9_]*$ ]]; then
    printf 'Invalid database name: %s\n' "${database}" >&2
    printf 'Database names must start with a letter and contain only letters, numbers, and underscores.\n' >&2
    return 1
  fi
}

require_command() {
  local command_name="$1"

  if ! command -v "${command_name}" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "${command_name}" >&2
    return 1
  fi
}

require_running_container() {
  local container="$1"

  if [[ "$(docker inspect --format '{{.State.Running}}' "${container}" 2>/dev/null || true)" != "true" ]]; then
    printf 'Required container is not running: %s\n' "${container}" >&2
    return 1
  fi
}

sha256_file() {
  local path="$1"

  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "${path}" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "${path}" | awk '{print $1}'
  else
    printf 'Neither sha256sum nor shasum is available.\n' >&2
    return 1
  fi
}

resolve_backup_path() {
  local supplied="${1:-}"
  local backup_dir="${BACKUP_DIR:-${BACKUP_REPO_ROOT}/backups/postgres}"

  if [[ -n "${supplied}" ]]; then
    if [[ "${supplied}" = /* ]]; then
      printf '%s' "${supplied}"
    else
      printf '%s' "${BACKUP_REPO_ROOT}/${supplied}"
    fi
    return
  fi

  if [[ ! -f "${backup_dir}/LATEST" ]]; then
    printf 'No backup was supplied and %s/LATEST does not exist.\n' "${backup_dir}" >&2
    return 1
  fi

  local latest
  latest="$(<"${backup_dir}/LATEST")"
  printf '%s/%s' "${backup_dir}" "${latest}"
}

manifest_path_for() {
  local backup_path="$1"
  printf '%s.manifest.json' "${backup_path%.dump}"
}

checksum_path_for() {
  local backup_path="$1"
  printf '%s.sha256' "${backup_path%.dump}"
}

verify_backup_checksum() {
  local backup_path="$1"
  local checksum_path
  checksum_path="$(checksum_path_for "${backup_path}")"

  if [[ ! -f "${checksum_path}" ]]; then
    printf 'Checksum file not found: %s\n' "${checksum_path}" >&2
    return 1
  fi

  local expected actual
  expected="$(awk '{print $1; exit}' "${checksum_path}")"
  actual="$(sha256_file "${backup_path}")"

  if [[ "${expected}" != "${actual}" ]]; then
    printf 'Checksum verification failed for %s\n' "${backup_path}" >&2
    printf 'Expected: %s\nActual:   %s\n' "${expected}" "${actual}" >&2
    return 1
  fi
}
