#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"

# source utils
source "${DIR}/../../utils/create_symlink.sh"

configure_starship() {
  mkdir -p "${CONFIG_DIR}"
  create_symlink "${DIR}/starship.toml" "${CONFIG_DIR}/starship.toml"
}

configure_starship
