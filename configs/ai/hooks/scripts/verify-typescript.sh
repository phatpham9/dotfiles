#!/usr/bin/env bash
set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0

input="$(cat)"
[ "${AI_HOOK_VERIFY:-1}" = "1" ] || exit 0

# Avoid a stop loop: only enforce once per stop cycle.
if [ "$(jq -r '.stop_hook_active // false' <<<"$input" 2>/dev/null || true)" = "true" ]; then
  exit 0
fi

project="${CLAUDE_PROJECT_DIR:-$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null || true)}"
project="${project:-$PWD}"
cd "$project" || exit 0
[ -f package.json ] || exit 0

has_script() {
  jq -e --arg s "$1" '.scripts[$s] != null' package.json >/dev/null 2>&1
}

pm="npm"
if [ -f pnpm-lock.yaml ]; then
  pm="pnpm"
elif [ -f yarn.lock ]; then
  pm="yarn"
elif [ -f bun.lockb ]; then
  pm="bun"
elif [ -f package-lock.json ]; then
  pm="npm"
fi

if has_script typecheck; then
  if ! "$pm" run typecheck; then
    echo "ai hook: typecheck failed; fix errors before finishing." >&2
    exit 2
  fi
elif [ -f tsconfig.json ] && [ -x "node_modules/.bin/tsc" ]; then
  if ! node_modules/.bin/tsc --noEmit; then
    echo "ai hook: tsc --noEmit failed; fix errors before finishing." >&2
    exit 2
  fi
else
  exit 0
fi

if [ "${AI_HOOK_RUN_TESTS:-0}" = "1" ] && has_script test; then
  if ! "$pm" test; then
    echo "ai hook: tests failed; fix them before finishing." >&2
    exit 2
  fi
fi

exit 0
