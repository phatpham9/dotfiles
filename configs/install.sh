#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# create symbolic links
create_symlink() {
  ln -sf "${DIR}/$1" "${HOME}/$2"
}

# configure ssh
configure_ssh() {
  ssh-keygen -t ed25519 -C "phat@onroads.xyz" -f "${HOME}/.ssh/id_ed25519" -P ""
  ssh-keygen -t ed25519 -C "phatttpham9@gmail.com" -f "${HOME}/.ssh/id_ed25519_secondary" -P ""
  create_symlink "ssh/config" ".ssh/config"
  create_symlink "ssh/config_secondary" ".ssh/config_secondary"
  echo "-> ssh key generated & configured!"
  echo "-> Attention! Don't forget to copy the public key & add it to remote hosts such as github.com & gitlab.com."
}

# configure git
configure_git() {
  create_symlink "git/gitconfig" ".gitconfig"
  create_symlink "git/gitconfig_secondary" ".gitconfig_secondary"
  create_symlink "git/gitignore_global" ".gitignore_global"
  echo "-> git configured!"
}

# configure gh
configure_gh() {
  if [ ! -d "${HOME}/.config/gh" ]; then
    mkdir -p "${HOME}/.config/gh"
  fi
  create_symlink "gh/config.yml" ".config/gh/config.yml"
  create_symlink "gh/hosts.yml" ".config/gh/hosts.yml"
  echo "-> gh configured!"
}

# configure zsh
configure_zsh() {
  create_symlink "zsh/zshrc" ".zshrc"
  echo "-> zsh configured!"
}

# call the configuration functions
configure_ssh
configure_git
configure_gh
configure_zsh

# install gh extensions
install_gh_extensions() {
  while IFS= read -r extension; do
    gh extension install "$extension"
  done < "${DIR}/gh/extensions"
  echo "-> gh extensions installed!"
}

# call the extension installation functions
install_gh_extensions
