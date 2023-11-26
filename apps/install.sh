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
  sudo apt-get install gcc build-essential procps file curl git zsh
  chsh -s $(which zsh)  # change the default shell to zsh. prompt for password
  echo "-> build tools installed!"
fi

# install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "-> oh-my-zsh installed!"
fi

# install brew
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "-> brew installed!"
  if is_macos; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# install cli & gui apps
brew bundle --file=${DIR}/Brewfile_cli
if is_macos; then
  brew bundle --file=${DIR}/Brewfile_macos
  echo "-> cli & gui apps installed!"
else
  echo "-> cli apps installed!"
fi
