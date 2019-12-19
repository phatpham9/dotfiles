#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# install xcode
xcode-select --install

# install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install brew cli tools & cask macos apps
brew bundle

# install npm cli tools
yarn global add $(cat ${DIR}/yarn | tr '\n' ' ')

# install brave extensions
# wip

# install station apps
# wip

# install vscode extensions
code --install-extension $(cat ${DIR}/vscode | tr '\n' ' ')
