#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# zsh
ln -s ${DIR}/zsh/zshrc ~/.zshrc
echo "-> zsh configured!"

# ssh
ssh-keygen -t ed25519 -C "phatpham9@gmail.com" -f "${HOME}/.ssh/id_ed25519" -P ""
ln -s ${DIR}/ssh/config ~/.ssh/config
echo "-> ssh key generated & configured!"
echo "-> Attention! Don't forget to copy the public key & add it to remote hosts such as github.com & gitlab.com."

# gpg
gpg --batch --generate-key "gpg/generate-key"
gpg --armor --export phatpham9@gmail.com
echo "-> gpg key generated!"
echo "-> Attention! Don't forget to copy the public key & add it to remote hosts such as github.com & gitlab.com."

# git
ln -s ${DIR}/git/gitconfig ~/.gitconfig
ln -s ${DIR}/git/gitignore_global ~/.gitignore_global
git config --global user.signingkey $(gpg --list-keys --keyid-format LONG | grep -E -o -m 1 "[0-9A-F]{16}")
echo "-> git configured!"
echo "-> Attention! Global git config \"user.signingkey\" has been updated. Don't forget to commit & push your changes to remote repository."

# docker
ln -s ${DIR}/docker/daemon.json ~/.docker/daemon.json
ln -s ${DIR}/docker/config.json ~/.docker/config.json
echo "-> docker configured!"

# minikube
ln -s ${DIR}/minikube/config.json ~/.minikube/config/config.json
echo "-> minikube configured!"

# vscode
ln -s ${DIR}/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ${DIR}/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
ln -s ${DIR}/vscode/projects.json ~/Library/Application\ Support/Code/User/projects.json
echo "-> vscode configured!"

# brave
echo "-> brave configuration skipped! Manual works needed for now such as preferences configuration & bookmarks import."
