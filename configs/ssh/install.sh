#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_DIR="${HOME}/.ssh"

# source utils
source "${DIR}/../../utils/generate_ssh_key.sh"
source "${DIR}/../../utils/create_symlink.sh"

configure_ssh() {
  mkdir -p "${SSH_DIR}"
  generate_ssh_key "${SSH_DIR}/id_ed25519" "phat@onroads.xyz"
  create_symlink "${DIR}/config" "${SSH_DIR}/config"
}

configure_ssh
