#!/bin/bash
set -e
set -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

upgrade_codegraph
upgrade_uv_tool openviking
upgrade_uv_tool markitdown
