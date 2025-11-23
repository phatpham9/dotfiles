#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source utils
source "${DIR}/../utils/is_macos.sh"

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
    
    # set up shell environment
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
  "${DIR}/cli/install.sh"

  echo "-> cli apps installed!"
}

# install gui apps (macOS only)
install_gui_apps() {
  "${DIR}/gui/install.sh"

  echo "-> gui apps installed!"
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
