#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# xcode
xcode-select --install
# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# brew cli tools & macos apps
brew bundle
# npm cli tools
yarn global add $(cat ${DIR}/yarn | tr '\n' ' ')
# vscode extensions
code --install-extension $(cat ${DIR}/code | tr '\n' ' ')
