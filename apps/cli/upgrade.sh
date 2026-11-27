#!/bin/bash
set -e
set -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# reuse the checksum-verified tofu-ls installer without running the full install
# shellcheck source=install.sh
source "${DIR}/install.sh"

upgrade_codegraph() {
  if ! command -v codegraph >/dev/null 2>&1; then
    echo "-> codegraph not installed; run ${DIR}/install.sh first"
    return
  fi

  codegraph upgrade
}

upgrade_uv_tool() {
  local tool="$1"

  if ! uv tool list 2>/dev/null | grep -q "^${tool} "; then
    echo "-> ${tool} not installed; run ${DIR}/install.sh first"
    return
  fi

  uv tool upgrade "${tool}"
}

upgrade_tofu_ls() {
  if ! command -v tofu-ls >/dev/null 2>&1; then
    echo "-> tofu-ls not installed; run ${DIR}/install.sh first"
    return
  fi

  install_tofu_ls
}

upgrade_playwright_cli() {
  if ! command -v playwright-cli >/dev/null 2>&1; then
    echo "-> playwright-cli not installed; run ${DIR}/install.sh first"
    return
  fi

  if ! command -v npm >/dev/null 2>&1; then
    echo "-> npm not found; cannot upgrade playwright-cli" >&2
    return
  fi

  npm install -g @playwright/cli@latest
}

upgrade_codegraph
upgrade_uv_tool openviking
upgrade_uv_tool markitdown
upgrade_tofu_ls
upgrade_playwright_cli
