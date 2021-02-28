#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# zsh
ln -s ${DIR}/zsh/zshrc ~/.zshrc
echo "-> zsh configured!"

# git
ln -s ${DIR}/git/gitconfig ~/.gitconfig
ln -s ${DIR}/git/gitignore_global ~/.gitignore_global
echo "-> git configured!"

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
cp ${DIR}/vscode/projects.json ~/Library/Application\ Support/Code/User/projects.json
echo "-> vscode configured!"
