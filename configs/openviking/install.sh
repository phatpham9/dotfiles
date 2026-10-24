#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENVIKING_DIR="${HOME}/.openviking"
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"
LAUNCH_AGENT_LABEL="ai.openviking.server"

# source utils
source "${DIR}/../../utils/create_symlink.sh"
source "${DIR}/../../utils/is_macos.sh"

install_launch_agent() {
  if ! command -v openviking-server >/dev/null 2>&1; then
    echo "-> openviking-server not installed; skipping launch agent"
    return
  fi

  mkdir -p "${LAUNCH_AGENTS_DIR}" "${OPENVIKING_DIR}/logs"
  sed "s#__HOME__#${HOME}#g" \
    "${DIR}/ai.openviking.server.plist.template" \
    > "${LAUNCH_AGENTS_DIR}/${LAUNCH_AGENT_LABEL}.plist"

  launchctl bootout "gui/$(id -u)/${LAUNCH_AGENT_LABEL}" 2>/dev/null || true

  # bootout can race with bootstrap; retry briefly until the service is removed
  local attempt
  for attempt in 1 2 3; do
    if launchctl bootstrap "gui/$(id -u)" "${LAUNCH_AGENTS_DIR}/${LAUNCH_AGENT_LABEL}.plist" 2>/dev/null; then
      return
    fi
    sleep 1
  done

  echo "-> Failed to load ${LAUNCH_AGENT_LABEL} launch agent" >&2
  return 1
}

configure_openviking() {
  mkdir -p "${OPENVIKING_DIR}"

  create_symlink "${DIR}/ovcli.conf" "${OPENVIKING_DIR}/ovcli.conf"
  create_symlink "${DIR}/ovcli.settings.conf" "${OPENVIKING_DIR}/ovcli.settings.conf"

  # ov.conf contains provider API keys and is intentionally not tracked
  if [ ! -f "${OPENVIKING_DIR}/ov.conf" ]; then
    echo "-> Warning: ${OPENVIKING_DIR}/ov.conf is missing; run 'ov config' to create it"
  fi

  if is_macos; then
    install_launch_agent
  fi
}

configure_openviking
