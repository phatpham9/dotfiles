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
  sudo apt-get install build-essential procps file curl git zsh
  echo "-> curl git zsh installed!"
fi

# install brew
if ! command -v brew &> /dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "-> brew installed!"
  if is_macos; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew install gcc
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# install cli & gui apps
brew bundle --file=${DIR}/Brewfile_cli
if is_macos; then
  brew bundle --file=${DIR}/Brewfile_gui
  echo "-> cli & gui apps installed!"
else
  echo "-> cli apps installed!"
fi

# install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "-> oh-my-zsh installed!"
fi
