#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# Ask for the administrator password upfront
sudo -v


# Set up macos
echo '1. Configuring MacOS...'
echo '-> MacOS configuration skipped!'
# ./macos/install.sh
# echo '-> MacOS configured!'


# Install apps
echo '2. Installing apps...'
./apps/install.sh
echo '-> Apps installed!'


# Creates symlinks
echo '3. Creating symlinks...'
# zsh
ln -s ${DIR}/zsh/zshrc ~/.zshrc
# git
ln -s ${DIR}/git/gitconfig ~/.gitconfig
ln -s ${DIR}/git/gitignore_global ~/.gitignore_global
# docker
ln -s ${DIR}/docker/daemon.json ~/.docker/daemon.json
ln -s ${DIR}/docker/config.json ~/.docker/config.json
# minikube
ln -s ${DIR}/minikube/config.json ~/.minikube/config/config.json
# vscode
ln -s ${DIR}/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ${DIR}/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
cp ${DIR}/vscode/projects.json ~/Library/Application\ Support/Code/User/projects.json
echo '-> Symlinks created!'

# Restart
echo '4. Done! Restart your computer to take effect.'
