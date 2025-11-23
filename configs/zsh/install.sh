#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source utils
source "${DIR}/../../utils/create_symlink.sh"

configure_zsh() {
  create_symlink "${DIR}/zsh_aliases" "${HOME}/.zsh_aliases"
  create_symlink "${DIR}/zshrc" "${HOME}/.zshrc"
}

configure_zsh
