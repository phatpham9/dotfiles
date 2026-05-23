#!/bin/bash
set -e
set -o pipefail

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
    HOMEBREW_BUNDLE_BREW_SKIP="colima macmon" brew bundle --file="${DIR}/Brewfile"
  fi
}

install_codegraph() {
  if command -v codegraph >/dev/null 2>&1; then
    return
  fi

  curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
}

install_cli_apps
install_codegraph
