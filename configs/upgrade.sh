#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# re-run the config installers to link new configs and refresh generated files
refresh_configs() {
  "${DIR}/install.sh"

  echo "-> Configs refreshed!"
}

# upgrade installed Claude Code plugins and marketplaces
upgrade_ai() {
  if command -v claude >/dev/null 2>&1; then
    "${DIR}/ai/upgrade.sh"

    echo "-> AI plugins upgraded!"
  else
    echo "-> claude CLI not found; skipping AI upgrades"
  fi
}

refresh_configs
upgrade_ai
