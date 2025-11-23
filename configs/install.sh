#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_DIR="${HOME}/.ssh"
CONFIG_DIR="${HOME}/.config"
GH_DIR="${CONFIG_DIR}/gh"
DOCKER_DIR="${HOME}/.docker"

# check if running on macOS
is_macos() {
  [[ $(uname) == "Darwin" ]]
}

# create symbolic links
create_symlink() {
  ln -sf "${DIR}/$1" "${HOME}/$2"
  echo "-> Symlink created for $1"
}

# configure ssh
configure_ssh() {
  mkdir -p "${SSH_DIR}"
  if [ ! -f "${SSH_DIR}/id_ed25519" ]; then
    ssh-keygen -t ed25519 -C "phat@onroads.xyz" -f "${SSH_DIR}/id_ed25519" -P ""
  else
    echo "-> SSH key id_ed25519 already exists."
  fi
  create_symlink "ssh/config" ".ssh/config"
  echo "-> SSH keys generated & configured!"
}

# configure git
configure_git() {
  create_symlink "git/gitconfig" ".gitconfig"
  create_symlink "git/gitignore_global" ".gitignore_global"
  echo "-> Git configured!"
}

# configure gh
configure_gh() {
  mkdir -p "${GH_DIR}"
  create_symlink "gh/config.yml" ".config/gh/config.yml"
  create_symlink "gh/hosts.yml" ".config/gh/hosts.yml"
  echo "-> GitHub CLI configured!"
}

# configure docker
configure_docker() {
  mkdir -p "${DOCKER_DIR}"
  create_symlink "docker/config.json" ".docker/config.json"
  echo "-> Docker configured!"
}

# configure zsh
configure_zsh() {
  create_symlink "zsh/zsh_aliases" ".zsh_aliases"
  create_symlink "zsh/zshrc" ".zshrc"
  echo "-> Zsh configured!"
}

# configure starship
configure_starship() {
  mkdir -p "${CONFIG_DIR}"
  create_symlink "starship/starship.toml" ".config/starship.toml"
  echo "-> Starship configured!"
}

# Main script execution
configure_ssh
configure_git
configure_gh
configure_docker
configure_zsh
configure_starship
