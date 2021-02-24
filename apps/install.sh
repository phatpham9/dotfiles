#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# install xcode
xcode-select --install

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update

# install brew cli tools & cask macos apps
brew bundle --file=${DIR}/

# install node binaries
for node in $(cat "${DIR}/nvm" | tr "\n" " "); do nvm install "${node}"; done

# install npm cli tools
yarn global add $(cat "${DIR}/npm" | tr "\n" " ")

# install station apps
# wip

# install brave extensions
# wip

# install vscode extensions
code --install-extension $(cat "${DIR}/vscode" | tr "\n" " ")
