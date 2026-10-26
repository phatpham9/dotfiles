#!/usr/bin/env bash
set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0

input="$(cat)"
[ "${AI_HOOK_FORMAT:-1}" = "1" ] || exit 0

file_path="$(jq -r '.tool_input.file_path // empty' <<<"$input" 2>/dev/null || true)"
[ -z "$file_path" ] && exit 0
[ -f "$file_path" ] || exit 0

project="${CLAUDE_PROJECT_DIR:-$(jq -r '.cwd // empty' <<<"$input" 2>/dev/null || true)}"
project="${project:-$PWD}"

case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.json|*.css|*.scss|*.md|*.mdx|*.yaml|*.yml) ;;
  *) exit 0 ;;
esac

prettier="${project}/node_modules/.bin/prettier"
eslint="${project}/node_modules/.bin/eslint"

format_failed=0

if [ -x "$prettier" ]; then
  if ! prettier_output="$("$prettier" --write --ignore-unknown "$file_path" 2>&1)"; then
    echo "ai hook: prettier failed on ${file_path}: ${prettier_output}" >&2
    format_failed=1
  fi
fi

if [ -x "$eslint" ]; then
  if ! eslint_output="$("$eslint" --fix "$file_path" 2>&1)"; then
    echo "ai hook: eslint failed on ${file_path}: ${eslint_output}" >&2
    format_failed=1
  fi
fi

[ "$format_failed" -eq 0 ] || exit 2
exit 0
