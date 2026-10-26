#!/bin/bash
# Emit the Authorization header for the GitHub MCP server, sourcing the token
# from the gh CLI (stored in the macOS keyring). No secret is written to config.
set -euo pipefail

command -v gh >/dev/null 2>&1 || {
  echo "github-mcp-auth: gh is not installed" >&2
  exit 1
}

token="$(gh auth token)"
[ -n "$token" ] || {
  echo "github-mcp-auth: gh auth token returned an empty token" >&2
  exit 1
}

printf '{"Authorization":"Bearer %s"}' "$token"
