#!/usr/bin/env bash
set -euo pipefail

command -v jq >/dev/null 2>&1 || exit 0

input="$(cat)"
file_path="$(jq -r '.tool_input.file_path // empty' <<<"$input" 2>/dev/null || true)"
[ -z "$file_path" ] && exit 0

case "$file_path" in
  .env.example|*.env.example|.env.sample|*.env.sample|.env.template|*.env.template|.env.dist|*.env.dist)
    exit 0
    ;;
esac

case "$file_path" in
  .env|.env.*|*.env|*.env.*|.envrc|.npmrc|.pypirc|.netrc|.git-credentials|*.pem|*.key|*.p12|*.pfx|*.jks|*.p8|id_rsa|id_ed25519|.ssh/*|.aws/credentials|.docker/config.json|.kube/config|*/.ssh/*|*/.aws/credentials|*/.docker/config.json|*/.kube/config)
    echo "Blocked by ai hook: refusing to edit sensitive file: $file_path" >&2
    exit 2
    ;;
esac

exit 0
