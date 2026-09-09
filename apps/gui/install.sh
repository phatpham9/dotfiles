#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source utils
source "${DIR}/../../utils/is_macos.sh"

# oMLX desktop app is not available as a cask; install from the upstream
# GitHub Releases dmg (macOS 15 and macOS 26+ ship as separate builds)
install_omlx_app() {
  if [ -d "/Applications/oMLX.app" ]; then
    return
  fi

  local tag dmg_url tmp_dir mount_dir
  tag="$(curl -fsSL https://api.github.com/repos/jundot/omlx/releases/latest | jq -r .tag_name)"

  local macos_major
  macos_major="$(sw_vers -productVersion | cut -d. -f1)"
  if [ "$macos_major" -ge 26 ]; then
    dmg_url="https://github.com/jundot/omlx/releases/download/${tag}/oMLX-${tag#v}-macos26-27.dmg"
  else
    dmg_url="https://github.com/jundot/omlx/releases/download/${tag}/oMLX-${tag#v}-macos15-sequoia.dmg"
  fi

  tmp_dir="$(mktemp -d)"
  mount_dir="${tmp_dir}/mnt"
  mkdir -p "${mount_dir}"
  curl -fL "${dmg_url}" -o "${tmp_dir}/oMLX.dmg"
  hdiutil attach "${tmp_dir}/oMLX.dmg" -nobrowse -quiet -mountpoint "${mount_dir}"
  cp -R "${mount_dir}/oMLX.app" /Applications/
  hdiutil detach "${mount_dir}" -quiet
  rm -rf "${tmp_dir}"
}

install_gui_apps() {
  if is_macos; then
    brew bundle --file="${DIR}/Brewfile"
    install_omlx_app
  fi
}

install_gui_apps
