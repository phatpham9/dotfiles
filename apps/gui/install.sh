#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source utils
source "${DIR}/../../utils/is_macos.sh"

install_gui_apps() {
  if is_macos; then
    brew bundle --file="${DIR}/Brewfile"
  fi
}

install_gui_apps
