#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# configure ssh
ssh-keygen -t ed25519 -C "phat@onroads.xyz" -f "${HOME}/.ssh/id_ed25519" -P ""
ssh-keygen -t ed25519 -C "phatttpham9@gmail.com" -f "${HOME}/.ssh/id_ed25519_secondary" -P ""
ssh-keygen -t ed25519 -C "phat.pham@setel.com" -f "${HOME}/.ssh/id_ed25519_setel" -P ""
ln -sf ${DIR}/ssh/config ${HOME}/.ssh/config
ln -sf ${DIR}/ssh/config_secondary ${HOME}/.ssh/config_secondary
ln -sf ${DIR}/ssh/config_setel ${HOME}/.ssh/config_setel
echo "-> ssh key generated & configured!"
echo "-> Attention! Don't forget to copy the public key & add it to remote hosts such as github.com & gitlab.com."

# configure git
ln -sf ${DIR}/git/gitconfig ${HOME}/.gitconfig
ln -sf ${DIR}/git/gitconfig_secondary ${HOME}/.gitconfig_secondary
ln -sf ${DIR}/git/gitconfig_setel ${HOME}/.gitconfig_setel
ln -sf ${DIR}/git/gitignore_global ${HOME}/.gitignore_global
echo "-> git configured!"

# configure gh
ln -sf ${DIR}/gh/config.yml ${HOME}/.config/gh/config.yml
ln -sf ${DIR}/gh/hosts.yml ${HOME}/.config/gh/hosts.yml
ln -sf ${DIR}/gh/config.yml ${HOME}/.config/gh_secondary/config.yml
ln -sf ${DIR}/gh/hosts.yml_secondary ${HOME}/.config/gh_secondary/hosts.yml
ln -sf ${DIR}/gh/config.yml ${HOME}/.config/gh_setel/config.yml
ln -sf ${DIR}/gh/hosts.yml_setel ${HOME}/.config/gh_setel/hosts.yml
echo "-> gh configured!"

# configure zsh
ln -sf ${DIR}/zsh/zshrc ${HOME}/.zshrc
echo "-> zsh configured!"
