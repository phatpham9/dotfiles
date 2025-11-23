#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"

# source utils
source "${DIR}/../../utils/create_symlink.sh"

configure_gh() {
  mkdir -p "${CONFIG_DIR}/gh"
  create_symlink "${DIR}/config.yml" "${CONFIG_DIR}/gh/config.yml"
  create_symlink "${DIR}/hosts.yml" "${CONFIG_DIR}/gh/hosts.yml"
}

configure_gh
