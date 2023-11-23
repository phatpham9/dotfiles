#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# xcode
xcode-select --install
echo "-> xcode installed!"

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "-> brew installed!"

# cli & gui apps by brew
brew bundle --file=${DIR}/
echo "-> brew cli & gui apps installed!"

# node binaries by fnm
for node in $(cat "${DIR}/node" | tr "\n" " "); do fnm install "${node}"; done
echo "-> node binaries installed!"
