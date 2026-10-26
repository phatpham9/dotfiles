#!/usr/bin/env bash
set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0

input="$(cat)"
command="$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null || true)"
[ -z "$command" ] && exit 0

# Deliberately narrow patterns: routine cleanup (rm -rf node_modules) is allowed.
patterns=(
  'rm[[:space:]]+(-[^[:space:]]+[[:space:]]+)*/(\*)?($|[[:space:]])'
  'rm[[:space:]]+(-[^[:space:]]+[[:space:]]+)*(~|\$HOME)(/?\*?)?($|[[:space:]])'
  'rm[[:space:]]+(-[^[:space:]]+[[:space:]]+)*(/Users|/home)/[^/[:space:]]+($|[[:space:]])'
  'git[[:space:]]+push[[:space:]]+.*(--force([[:space:]]|$)|-f([[:space:]]|$)|[[:space:]]\+[^[:space:]]+)'
  '(kubectl|oc)[[:space:]]+delete[[:space:]]+(namespace|ns|pv|pvc|clusterrole|clusterrolebinding)'
  '(terraform|tofu)[[:space:]]+apply[[:space:]]+.*-auto-approve'
  'DROP[[:space:]]+(DATABASE|TABLE|SCHEMA)'
)

for pattern in "${patterns[@]}"; do
  if grep -Eiq -- "$pattern" <<<"$command"; then
    {
      echo "Blocked by ai hook: dangerous command matched '$pattern'."
      echo "Command: $command"
      echo "Ask the user to run it manually if it is intentional."
    } >&2
    exit 2
  fi
done

exit 0
