#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_DIR="${HOME}/.ssh"
GH_CONFIG_DIR="${HOME}/.config/gh"

# create symbolic links
create_symlink() {
  if [ -e "${HOME}/$2" ]; then
    echo "-> Skipping $2, already exists."
  else
    ln -sf "${DIR}/$1" "${HOME}/$2"
    echo "-> Symlink created for $1"
  fi
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
  create_symlink "ssh/config" ".ssh/config"
  create_symlink "ssh/config_secondary" ".ssh/config_secondary"
  echo "-> SSH keys generated & configured!"
  echo "-> Attention! Don't forget to copy the public key & add it to remote hosts such as github.com & gitlab.com."
}

# configure git
configure_git() {
  create_symlink "git/gitconfig" ".gitconfig"
  create_symlink "git/gitconfig_secondary" ".gitconfig_secondary"
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

# configure zsh
configure_zsh() {
  create_symlink "zsh/zsh_aliases" ".zsh_aliases"
  create_symlink "zsh/zshrc" ".zshrc"
  echo "-> Zsh configured!"
}

# config poetry
configure_poetry() {
  poetry config virtualenvs.in-project true
  echo "-> Poetry configured!"
}

# install gh extensions
install_gh_extensions() {
  while IFS= read -r extension; do
    gh extension install "$extension"
  done < "${DIR}/gh/extensions"
  echo "-> gh extensions installed!"
}

# Main script execution
configure_ssh
configure_git
configure_gh
configure_zsh
configure_poetry
install_gh_extensions
