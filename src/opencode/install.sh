#!/bin/bash

set -eu

# --- Options (safe defaults; the CLI exports these, we just guard them) -----
HOST="${HOST:-mbp-m4}"
PORT="${PORT:-1236}"

readonly featureDir="$(cd "$(dirname "$0")" && pwd)"
readonly configFile="${featureDir}/opencode.json"

log() {
  printf '\033[1m\033[97m\033[41m %s\033[0m\n' "$1"
}

write_config() {
  local home=$1 owner=${2:-}
  local dir="${home}/.config/opencode"

  mkdir -p "$dir"
  cp "$configFile" "${dir}/opencode.json"
  # Point the provider at the endpoint requested via the feature options.
  sed -i -E "s#(\"baseURL\":[[:space:]]*)\"[^\"]*\"#\\1\"http://${HOST}:${PORT}/v1\"#g" "${dir}/opencode.json"

  if [ "$(id -u)" = "0" ] && [ -n "$owner" ] && id "$owner" >/dev/null 2>&1; then
    chown -R "$owner" "$dir" 2>/dev/null || true
  fi
  echo "Wrote ${dir}/opencode.json (endpoint http://${HOST}:${PORT}/v1)"
}

main() {
  log "devcontainer feature: opencode (config)"
  echo "  endpoint: http://${HOST}:${PORT}/v1"

  if [ ! -f "$configFile" ]; then
    echo "Expected config file ${configFile} is missing. Aborting." >&2
    exit 1
  fi

  local containerHome="${_CONTAINER_USER_HOME:-}"
  local remoteHome="${_REMOTE_USER_HOME:-}"
  local containerUser="${_CONTAINER_USER:-$(id -un)}"
  local remoteUser="${_REMOTE_USER:-${containerUser}}"

  # Fall back to the installer's home if the CLI did not report one.
  [ -n "$containerHome" ] || containerHome="${HOME:-/root}"

  write_config "$containerHome" "$containerUser"

  if [ -n "$remoteHome" ] && [ "$remoteHome" != "$containerHome" ]; then
    write_config "$remoteHome" "$remoteUser"
  fi

  if ! command -v opencode >/dev/null 2>&1; then
    echo "WARNING: the 'opencode' binary was not found on PATH." >&2
    echo "         This feature only writes configuration; it expects opencode to be" >&2
    echo "         installed by the 'opencode.ai' devcontainer feature" >&2
    echo "         (ghcr.io/devcontainer-community/devcontainer-features/opencode.ai)" >&2
    echo "         or provided by the base image." >&2
  else
    echo "opencode -> $(command -v opencode) ($(opencode --version 2>/dev/null || echo 'version unknown'))"
  fi

  log "Done"
}

main "$@"
