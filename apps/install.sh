#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# check if running on macOS
is_macos() {
  [[ $(uname) == "Darwin" ]]
}

# pre-install
if is_macos; then
  xcode-select --install
  echo "-> xcode installed!"
else
  sudo apt-get update
  sudo apt-get install gcc build-essential procps curl file git zsh
  # change the default shell to zsh
  chsh -s $(which zsh)
  echo "-> build tools installed!"
fi

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "-> brew installed!"
if is_macos; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# cli & gui apps by brew
if is_macos; then
  brew bundle --file=${DIR}/Brewfile_macos
  echo "-> brew cli & gui apps installed!"
else
  brew bundle --file=${DIR}/Brewfile
  echo "-> brew cli apps installed!"
fi
