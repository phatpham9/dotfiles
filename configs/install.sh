#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_DIR="${HOME}/.ssh"
GH_CONFIG_DIR="${HOME}/.config/gh"
DOCKER_CONFIG_DIR="${HOME}/.docker"

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
  if [ ! -f "${SSH_DIR}/id_ed25519_secondary" ]; then
    ssh-keygen -t ed25519 -C "phatttpham9@gmail.com" -f "${SSH_DIR}/id_ed25519_secondary" -P ""
  else
    echo "-> SSH key id_ed25519_secondary already exists."
  fi
  if [ ! -f "${SSH_DIR}/id_ed25519_saypien" ]; then
    ssh-keygen -t ed25519 -C "phat@saypien.io" -f "${SSH_DIR}/id_ed25519_saypien" -P ""
  else
    echo "-> SSH key id_ed25519_saypien already exists."
  fi
  create_symlink "ssh/config" ".ssh/config"
  create_symlink "ssh/config_secondary" ".ssh/config_secondary"
  create_symlink "ssh/config_saypien" ".ssh/config_saypien"
  echo "-> SSH keys generated & configured!"
  echo "-> Attention! Don't forget to copy the public key & add it to remote hosts such as github.com & gitlab.com."
}

# configure git
configure_git() {
  create_symlink "git/gitconfig" ".gitconfig"
  create_symlink "git/gitconfig_secondary" ".gitconfig_secondary"
  create_symlink "git/gitconfig_saypien" ".gitconfig_saypien"
  create_symlink "git/gitignore_global" ".gitignore_global"
  echo "-> Git configured!"
}

# configure gh
configure_gh() {
  mkdir -p "${GH_CONFIG_DIR}"
  create_symlink "gh/config.yml" ".config/gh/config.yml"
  create_symlink "gh/hosts.yml" ".config/gh/hosts.yml"
  echo "-> GitHub CLI configured!"
}

# configure docker
configure_docker() {
  mkdir -p "${DOCKER_CONFIG_DIR}"
  create_symlink "docker/config.json" ".docker/config.json"
  echo "-> Docker configured!"
}

# configure zsh
configure_zsh() {
  create_symlink "zsh/zsh_aliases" ".zsh_aliases"
  create_symlink "zsh/zshrc" ".zshrc"
  echo "-> Zsh configured!"
}

# install gh extensions
install_gh_extensions() {
  while IFS= read -r extension; do
    if is_macos; then
      /opt/homebrew/bin/gh extension install "$extension"
    else
      /home/linuxbrew/.linuxbrew/bin/gh extension install "$extension"
    fi
  done < "${DIR}/gh/extensions"
  echo "-> gh extensions installed!"
}

# Main script execution
configure_ssh
configure_git
configure_gh
configure_docker
configure_zsh
install_gh_extensions
