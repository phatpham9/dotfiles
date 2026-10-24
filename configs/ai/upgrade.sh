#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not found" >&2
  exit 1
fi

trim() {
  printf '%s' "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

marketplaces="$(claude plugin marketplace list 2>/dev/null || true)"

for marketplace in claude-plugins-official superpowers-marketplace claude-code-workflows ai-lsp; do
  if grep -q "$marketplace" <<<"$marketplaces"; then
    echo "-> Updating marketplace ${marketplace}"
    claude plugin marketplace update "$marketplace"
  fi
done

installed="$(claude plugin list 2>/dev/null || true)"

upgrade_file() {
  local file="$1" line plugin marketplace

  [ -f "$file" ] || return 0

  while IFS= read -r line || [ -n "$line" ]; do
    line="$(trim "${line%%#*}")"
    [ -z "$line" ] && continue

    plugin="${line%@*}"
    marketplace="${line##*@}"
    [ "$plugin" = "$marketplace" ] && continue

    if grep -qE "(^|[^[:alnum:]-])${plugin}(@|[^[:alnum:]-]|$)" <<<"$installed"; then
      echo "-> Updating ${plugin}"
      claude plugin update "$plugin" --scope user
    else
      echo "-> ${plugin} not installed; skipping"
    fi
  done < "$file"
}

upgrade_file "${DIR}/plugins.txt"
upgrade_file "${DIR}/plugins.optional.txt"

echo "-> MCP servers using npx/uvx resolve on demand."
echo "-> Upgrade codegraph/openviking with apps/cli/upgrade.sh."
