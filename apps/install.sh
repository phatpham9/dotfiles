#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# check if running on macOS
is_macos() {
  [[ $(uname) == "Darwin" ]]
}

# install dependencies
install_dependencies() {
  if is_macos; then
    xcode-select --install
    echo "-> xcode installed!"
  else
    sudo apt-get update
    sudo apt-get install -y build-essential procps file curl git zsh
    echo "-> curl git zsh installed!"
  fi
}

# install Homebrew
install_homebrew() {
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
}

# install cli apps
install_cli_apps() {
  brew bundle --file="${DIR}/Brewfile_cli"
  if is_macos; then
    chmod go-w "/opt/homebrew/share"
    chmod -R go-w "/opt/homebrew/share/zsh"
  fi
  echo "-> cli apps installed!"
}

# install gui apps (macOS only)
install_gui_apps() {
  if is_macos; then
    brew bundle --file="${DIR}/Brewfile_gui"
    echo "-> gui apps installed!"
  fi
}

# install oh-my-zsh
install_oh_my_zsh() {
  if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    RUNZSH=no /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "-> oh-my-zsh installed!"
  fi
}

# call the installation functions
install_dependencies
install_homebrew
install_cli_apps
install_gui_apps
install_oh_my_zsh
