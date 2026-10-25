#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENVIKING_DIR="${HOME}/.openviking"
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"
SERVER_AGENT_LABEL="ai.openviking.server"
INGEST_AGENT_LABEL="ai.openviking.ingest"

# source utils
source "${DIR}/../../utils/create_symlink.sh"
source "${DIR}/../../utils/is_macos.sh"

install_launch_agent() {
  local label="$1" template="$2"

  if ! command -v openviking-server >/dev/null 2>&1; then
    echo "-> openviking-server not installed; skipping ${label} launch agent"
    return
  fi

  mkdir -p "${LAUNCH_AGENTS_DIR}" "${OPENVIKING_DIR}/logs"
  sed "s#__HOME__#${HOME}#g" \
    "${DIR}/${template}" \
    > "${LAUNCH_AGENTS_DIR}/${label}.plist"

  launchctl bootout "gui/$(id -u)/${label}" 2>/dev/null || true

  # bootout can race with bootstrap; retry briefly until the service is removed
  local attempt
  for attempt in 1 2 3; do
    if launchctl bootstrap "gui/$(id -u)" "${LAUNCH_AGENTS_DIR}/${label}.plist" 2>/dev/null; then
      return
    fi
    sleep 1
  done

  echo "-> Failed to load ${label} launch agent" >&2
  return 1
}

configure_ingest() {
  local conf="${OPENVIKING_DIR}/ov.conf" tmp

  if ! command -v jq >/dev/null 2>&1; then
    echo "-> jq is required to configure OpenViking ingest; skipping" >&2
    return 0
  fi

  tmp="$(mktemp "${conf}.XXXXXX")"
  if ! jq --slurpfile ingest "${DIR}/ingest.json" \
    '.ingest = ((.ingest // {}) * $ingest[0])' "${conf}" > "${tmp}"; then
    rm -f "${tmp}"
    echo "-> Failed to update ${conf}; skipping ingest config" >&2
    return 0
  fi
  mv "${tmp}" "${conf}"
  echo "-> Configured OpenViking ingest in ${conf}"
}

configure_openviking() {
  mkdir -p "${OPENVIKING_DIR}"

  create_symlink "${DIR}/ovcli.conf" "${OPENVIKING_DIR}/ovcli.conf"
  create_symlink "${DIR}/ovcli.settings.conf" "${OPENVIKING_DIR}/ovcli.settings.conf"

  # ov.conf contains provider API keys and is intentionally not tracked
  if [ ! -f "${OPENVIKING_DIR}/ov.conf" ]; then
    echo "-> Warning: ${OPENVIKING_DIR}/ov.conf is missing; run 'ov config' to create it"
  else
    configure_ingest
  fi

  if is_macos; then
    install_launch_agent "${SERVER_AGENT_LABEL}" "ai.openviking.server.plist.template"
    install_launch_agent "${INGEST_AGENT_LABEL}" "ai.openviking.ingest.plist.template"
  fi
}

configure_openviking
