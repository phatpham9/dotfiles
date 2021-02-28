#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# xcode
xcode-select --install
echo "-> xcode installed!"

# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
echo "-> brew installed!"

# cli & gui apps by brew
brew bundle --file=${DIR}/
echo "-> cli & gui apps installed!"

# node binaries by nvm
for node in $(cat "${DIR}/nvm" | tr "\n" " "); do nvm "${node}"; done
echo "-> node binaries installed!"

# npm global packages by yarn
yarn global add $(cat "${DIR}/npm" | tr "\n" " ")
echo "-> npm global packages installed!"

# vscode extensions
code --install-extension $(cat "${DIR}/vscode" | tr "\n" " ")
echo "-> vscode extensions installed!"

# brave extensions
# wip
# echo "-> brave extensions installed!"
