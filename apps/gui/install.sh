#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source utils
source "${DIR}/../../utils/is_macos.sh"
source "${DIR}/../../utils/create_symlink.sh"

install_gui_apps() {
  if is_macos; then
    brew bundle --file="${DIR}/Brewfile"

    # Create symlink for Antigravity if it doesn't exist
    if is_macos; then
      if [ ! -L "/opt/homebrew/bin/agy" ]; then
        create_symlink "/Applications/Antigravity.app/Contents/Resources/app/bin/antigravity" "/opt/homebrew/bin/agy"
        
        echo "-> agy symlink created!"
      fi
    fi
  fi
}

install_gui_apps
