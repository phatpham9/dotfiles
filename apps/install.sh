#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# check if running on macOS
is_macos() {
  [[ $(uname) == "Darwin" ]]
}

# pre-install
if is_macos; then
  # xcode
  xcode-select --install
  echo "-> xcode installed!"
else
  sudo apt update
  sudo apt install build-essential procps curl file git
fi

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "-> brew installed!"
eval "$($(brew --prefix)/bin/brew shellenv)"

# cli & gui apps by brew
if is_macos; then
  brew bundle --file=${DIR}/Brewfile_macos
  echo "-> brew cli & gui apps installed!"
else
  brew bundle --file=${DIR}/Brewfile
  echo "-> brew cli apps installed!"
fi
