#!/usr/bin/env bash
set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0

input="$(cat)"
raw_command="$(jq -r '.tool_input.command // empty' <<<"$input" 2>/dev/null || true)"
[ -z "$raw_command" ] && exit 0

# Remove quotes and normalize ${HOME} so quoting cannot hide a target.
normalized_command="${raw_command//\"/}"
normalized_command="${normalized_command//\'/}"
normalized_command="${normalized_command//\$\{HOME\}/\$HOME}"

# Deliberately narrow patterns: routine cleanup (rm -rf node_modules) is
# allowed. Each pattern runs per shell segment so a trailing ;, |, or &
# cannot hide the dangerous part.
patterns=(
  'rm[[:space:]]+([^[:space:]]+[[:space:]]+)*/+[./*]*([[:space:]]|$)'
  'rm[[:space:]]+([^[:space:]]+[[:space:]]+)*(~[^/[:space:]]*|\$HOME)/?(\*+)?([[:space:]]|$)'
  'rm[[:space:]]+([^[:space:]]+[[:space:]]+)*(/Users|/home)/[^/[:space:]]+/?(\*+)?([[:space:]]|$)'
  'rm[[:space:]]+([^[:space:]]+[[:space:]]+)*(/Users|/home|/root|/etc|/usr|/var|/bin|/sbin|/lib|/lib64|/boot|/dev|/proc|/sys|/opt|/srv)/?(\*+)?([[:space:]]|$)'
  'rm[[:space:]]+([^[:space:]]+[[:space:]]+)*(\.|\.\.)([[:space:]]|$)'
  'git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?push[[:space:]]+.*(--force([[:space:]]|$)|-[a-zA-Z]*f[a-zA-Z]*([[:space:]]|$)|(^|[[:space:]])\+[^[:space:]]+)'
  '(kubectl|oc)[[:space:]]+delete[[:space:]]+(namespace|ns|pv|pvc|clusterrole|clusterrolebinding)'
  '(terraform|tofu)[[:space:]]+apply[[:space:]]+.*-auto-approve'
  'DROP[[:space:]]+(DATABASE|TABLE|SCHEMA)'
)

while IFS= read -r segment; do
  [ -z "$segment" ] && continue
  for pattern in "${patterns[@]}"; do
    if grep -Eiq -- "$pattern" <<<"$segment"; then
      {
        echo "Blocked by ai hook: dangerous command matched '$pattern'."
        echo "Command: $raw_command"
        echo "Ask the user to run it manually if it is intentional."
      } >&2
      exit 2
    fi
  done
done < <(printf '%s\n' "$normalized_command" | tr ';|&' '\n')

exit 0
