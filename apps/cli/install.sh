#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source utils
source "${DIR}/../../utils/is_macos.sh"

install_cli_apps() {
  if is_macos; then
    # Install all packages on macOS
    brew bundle --file="${DIR}/Brewfile"
    
    # zsh-completions compinit fix
    chmod go-w "/opt/homebrew/share"
    chmod -R go-w "/opt/homebrew/share/zsh"
  else
    # Install packages, skipping macOS-specific ones
    HOMEBREW_BUNDLE_BREW_SKIP="colima" brew bundle --file="${DIR}/Brewfile"
  fi
}

install_cli_apps
