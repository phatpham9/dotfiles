#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# configure ssh
configure_ssh() {
  "${DIR}/ssh/install.sh"
  
  echo "-> SSH keys generated & configured!"
}

# configure git
configure_git() {
  "${DIR}/git/install.sh"
  
  echo "-> Git configured!"
}

# configure gh
configure_gh() {
  "${DIR}/gh/install.sh"
  
  echo "-> GitHub CLI configured!"
}

# configure docker
configure_docker() {
  "${DIR}/docker/install.sh"
  
  echo "-> Docker configured!"
}

# configure zsh
configure_zsh() {
  "${DIR}/zsh/install.sh"
  
  echo "-> Zsh configured!"
}

# configure starship
configure_starship() {
  "${DIR}/starship/install.sh"
  
  echo "-> Starship configured!"
}

# configure openviking
configure_openviking() {
  "${DIR}/openviking/install.sh"

  echo "-> OpenViking configured!"
}

# configure ai (Claude Code)
configure_ai() {
  if command -v claude >/dev/null 2>&1; then
    "${DIR}/ai/install.sh"

    echo "-> AI configured!"
  else
    echo "-> claude CLI not found; skipping AI configuration"
  fi
}

# Main script execution
configure_ssh
configure_git
configure_gh
configure_docker
configure_zsh
configure_starship
configure_openviking
configure_ai
