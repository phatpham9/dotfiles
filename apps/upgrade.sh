#!/bin/bash
set -e
set -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source utils
source "${DIR}/../utils/is_macos.sh"

# upgrade Homebrew packages and install new Brewfile entries
upgrade_homebrew() {
  brew update
  brew upgrade

  if is_macos; then
    brew bundle --file="${DIR}/cli/Brewfile"
    brew bundle --file="${DIR}/gui/Brewfile"
  else
    HOMEBREW_BUNDLE_BREW_SKIP="colima macmon omlx" brew bundle --file="${DIR}/cli/Brewfile"
  fi

  echo "-> Homebrew packages upgraded!"
}

# restart omlx so the service uses the upgraded install
restart_omlx() {
  if ! is_macos; then
    return
  fi

  if brew services list 2>/dev/null | grep -qE "^omlx[[:space:]]+started"; then
    brew services restart omlx

    echo "-> omlx service restarted!"
  fi
}

# upgrade tools installed outside Homebrew
upgrade_cli_apps() {
  "${DIR}/cli/upgrade.sh"

  echo "-> CLI apps upgraded!"
}

# upgrade oh-my-zsh
upgrade_oh_my_zsh() {
  if [ -d "${HOME}/.oh-my-zsh/.git" ]; then
    git -C "${HOME}/.oh-my-zsh" pull --ff-only

    echo "-> oh-my-zsh upgraded!"
  fi
}

upgrade_homebrew
restart_omlx
upgrade_cli_apps
upgrade_oh_my_zsh
