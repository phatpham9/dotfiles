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
    HOMEBREW_BUNDLE_BREW_SKIP="colima macmon omlx" brew bundle --file="${DIR}/Brewfile"
  fi
}

install_uv_tools() {
  # OpenViking is installed with local embeddings support
  uv tool install "openviking[local-embed]"

  # MarkItDown CLI used by the markitdown MCP server, with all format extras
  uv tool install "markitdown[all]"
}

install_tofu_ls() {
  local os arch platform tag asset url tmp expected actual binary

  os="$(uname -s)"
  arch="$(uname -m)"

  case "${os}/${arch}" in
    Darwin/arm64) platform="Darwin_arm64" ;;
    Darwin/x86_64) platform="Darwin_x86_64" ;;
    Linux/aarch64|Linux/arm64) platform="Linux_arm64" ;;
    Linux/x86_64) platform="Linux_x86_64" ;;
    Linux/i386|Linux/i686) platform="Linux_i386" ;;
    *)
      echo "-> Unsupported platform for tofu-ls: ${os}/${arch}; skipping"
      return
      ;;
  esac

  tag="$(curl -fsSL https://api.github.com/repos/opentofu/tofu-ls/releases/latest | jq -r '.tag_name')"
  if [ -z "${tag}" ] || [ "${tag}" = "null" ]; then
    echo "-> Could not determine the latest tofu-ls release" >&2
    return 1
  fi

  asset="tofu-ls_${platform}.tar.gz"
  url="https://github.com/opentofu/tofu-ls/releases/download/${tag}/${asset}"
  tmp="$(mktemp -d)"

  curl -fsSL "${url}" -o "${tmp}/${asset}"
  curl -fsSL "https://github.com/opentofu/tofu-ls/releases/download/${tag}/tofu-ls_${tag#v}_checksums.txt" -o "${tmp}/checksums.txt"

  expected="$(awk -v asset="${asset}" '{ name = $2; sub(/^\*/, "", name); if (name == asset) print $1 }' "${tmp}/checksums.txt")"
  if command -v sha256sum >/dev/null 2>&1; then
    actual="$(sha256sum "${tmp}/${asset}" | awk '{ print $1 }')"
  else
    actual="$(shasum -a 256 "${tmp}/${asset}" | awk '{ print $1 }')"
  fi

  if [ -z "${expected}" ] || [ "${expected}" != "${actual}" ]; then
    echo "-> tofu-ls checksum verification failed" >&2
    rm -rf "${tmp}"
    return 1
  fi

  tar -xzf "${tmp}/${asset}" -C "${tmp}"
  binary="$(find "${tmp}" -type f -name tofu-ls | head -1)"
  if [ -z "${binary}" ]; then
    echo "-> tofu-ls binary not found in release archive" >&2
    rm -rf "${tmp}"
    return 1
  fi

  mkdir -p "${HOME}/.local/bin"
  install -m 0755 "${binary}" "${HOME}/.local/bin/tofu-ls"
  rm -rf "${tmp}"

  echo "-> tofu-ls ${tag} installed"
}

install_codegraph() {
  if command -v codegraph >/dev/null 2>&1; then
    return
  fi

  curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
}

install_cli_apps
install_uv_tools
install_tofu_ls
install_codegraph
