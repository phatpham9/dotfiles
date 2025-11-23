#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_DIR="${HOME}/.ssh"

# source utils
source "${DIR}/../../utils/create_symlink.sh"

configure_ssh() {
  mkdir -p "${SSH_DIR}"
  if [ ! -f "${SSH_DIR}/id_ed25519" ]; then
    ssh-keygen -t ed25519 -C "phat@onroads.xyz" -f "${SSH_DIR}/id_ed25519" -P ""
  else
    echo "-> SSH key id_ed25519 already exists."
  fi
  create_symlink "${DIR}/config" "${SSH_DIR}/config"
}

configure_ssh
