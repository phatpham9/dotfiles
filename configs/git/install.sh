#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source utils
source "${DIR}/../../utils/create_symlink.sh"

configure_git() {
  create_symlink "${DIR}/gitconfig" "${HOME}/.gitconfig"
  create_symlink "${DIR}/gitignore_global" "${HOME}/.gitignore_global"
  
  # Initialize git-lfs hooks
  git lfs install
}

configure_git
