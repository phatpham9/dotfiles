#!/bin/bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
SETTINGS_FILE="${CLAUDE_DIR}/settings.json"
ROUTING_FILE="${CLAUDE_DIR}/CLAUDE.md"
HOOKS_DIR="${CLAUDE_DIR}/hooks/ai"

WITH_HOOKS=0
WITH_OPTIONAL=0
WITH_ROUTING=1
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: install.sh [options]

Installs the Claude Code AI stack defined in this directory.

Options:
  --with-optional   Also install plugins from plugins.optional.txt
  --with-hooks      Install hook scripts and merge them into ~/.claude/settings.json
  --no-routing      Do not link or update ~/.claude/CLAUDE.md
  --all             Same as --with-optional --with-hooks
  --dry-run         Print actions without changing anything
  -h, --help        Show this help
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --with-optional) WITH_OPTIONAL=1 ;;
    --with-hooks) WITH_HOOKS=1 ;;
    --no-routing) WITH_ROUTING=0 ;;
    --all) WITH_OPTIONAL=1; WITH_HOOKS=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
  shift
done

log() { printf '%s\n' "-> $*"; }

trim() {
  printf '%s' "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '   [dry-run]'
    printf ' %q' "$@"
    printf '\n'
    return 0
  fi
  "$@"
}

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

require jq
if [ "$DRY_RUN" -eq 0 ]; then
  require claude
fi

marketplace_source() {
  case "$1" in
    claude-plugins-official) echo "anthropics/claude-plugins-official" ;;
    superpowers-marketplace) echo "obra/superpowers-marketplace" ;;
    claude-code-workflows) echo "wshobson/agents" ;;
    ai-lsp) echo "${DIR}/lsp" ;;
    *)
      echo "Unknown marketplace: $1" >&2
      return 1
      ;;
  esac
}

# Read plugin@marketplace lines from a list file.
each_plugin() {
  local file="$1" line plugin marketplace
  [ -f "$file" ] || return 0

  while IFS= read -r line || [ -n "$line" ]; do
    line="$(trim "${line%%#*}")"
    [ -z "$line" ] && continue

    plugin="${line%@*}"
    marketplace="${line##*@}"
    if [ "${plugin}" = "${marketplace}" ]; then
      echo "Invalid plugin entry (expected plugin@marketplace): ${line}" >&2
      exit 1
    fi

    printf '%s\t%s\n' "$plugin" "$marketplace"
  done < "$file"
}

add_marketplaces() {
  local file line marketplace seen=" "

  for file in "${DIR}/plugins.txt" "${DIR}/plugins.optional.txt"; do
    if [ "$file" = "${DIR}/plugins.optional.txt" ] && [ "$WITH_OPTIONAL" -eq 0 ]; then
      continue
    fi

    while IFS=$'\t' read -r _ marketplace; do
      case "$seen" in
        *" ${marketplace} "*) continue ;;
      esac
      seen="${seen}${marketplace} "

      log "Adding marketplace ${marketplace}"
      run claude plugin marketplace add "$(marketplace_source "$marketplace")" --scope user
    done < <(each_plugin "$file")
  done
}

install_plugins() {
  local file plugin marketplace
  local files=("${DIR}/plugins.txt")
  [ "$WITH_OPTIONAL" -eq 1 ] && files+=("${DIR}/plugins.optional.txt")

  add_marketplaces

  for file in "${files[@]}"; do
    while IFS=$'\t' read -r plugin marketplace; do
      log "Installing ${plugin} from ${marketplace}"
      run claude plugin install "${plugin}@${marketplace}" --scope user
    done < <(each_plugin "$file")
  done
}

# Remove user-scope copies of servers now provided by official plugins.
cleanup_legacy_mcp() {
  local name
  for name in github-mcp-server context7 playwright-mcp chrome-devtools-mcp huggingface; do
    if [ "$DRY_RUN" -eq 1 ]; then
      printf '   [dry-run] claude mcp remove %s --scope user (if present)\n' "$name"
    else
      claude mcp remove "$name" --scope user >/dev/null 2>&1 || true
    fi
  done
}

install_mcp_servers() {
  local row name cfg
  while IFS= read -r row; do
    name="$(jq -r '.key' <<<"$row")"
    cfg="$(jq -c '.value' <<<"$row")"
    cfg="$(jq -c --arg home "$HOME" 'walk(if type == "string" then gsub("\\$\\{HOME\\}"; $home) else . end)' <<<"$cfg")"

    log "Configuring MCP server ${name}"
    if [ "$DRY_RUN" -eq 1 ]; then
      printf '   [dry-run] claude mcp remove %s --scope user (if present)\n' "$name"
      printf '   [dry-run] claude mcp add-json %s %q --scope user\n' "$name" "$cfg"
    else
      claude mcp remove "$name" --scope user >/dev/null 2>&1 || true
      claude mcp add-json "$name" "$cfg" --scope user
    fi
  done < <(jq -c '.mcpServers | to_entries[]' "${DIR}/mcp.json")
}

install_mcp_headers() {
  local bin_dir="${HOME}/.local/bin" src
  if [ "$DRY_RUN" -eq 1 ]; then
    log "[dry-run] Would install MCP header helpers to ${bin_dir}"
    return
  fi
  mkdir -p "$bin_dir"
  for src in "${DIR}/mcp-headers/"*.sh; do
    [ -f "$src" ] || continue
    cp "$src" "$bin_dir/"
    chmod +x "$bin_dir/$(basename "$src")"
    log "Installed $(basename "$src") -> ${bin_dir}"
  done
}

resolve_routing_target() {
  local target="$ROUTING_FILE"

  if [ -L "$target" ]; then
    target="$(readlink "$target")"
    case "$target" in
      /*) ;;
      *) target="$(dirname "$ROUTING_FILE")/$target" ;;
    esac
  fi

  printf '%s\n' "$target"
}

link_claude_md() {
  local source="${DIR}/CLAUDE.md"

  [ -f "$source" ] || return 1

  if [ "$DRY_RUN" -eq 1 ]; then
    log "[dry-run] Would link ${ROUTING_FILE} -> ${source} if absent"
    return 0
  fi

  if [ -L "$ROUTING_FILE" ]; then
    if [ "$(readlink "$ROUTING_FILE")" = "$source" ]; then
      return 0
    fi
    echo "-> ${ROUTING_FILE} is a symlink to $(readlink "$ROUTING_FILE"); leaving it unchanged" >&2
    return 1
  fi

  if [ -e "$ROUTING_FILE" ]; then
    echo "-> ${ROUTING_FILE} exists and is not a symlink; leaving it unchanged" >&2
    return 1
  fi

  mkdir -p "$(dirname "$ROUTING_FILE")"
  ln -s "$source" "$ROUTING_FILE"
  log "Linked ${ROUTING_FILE} -> ${source}"
}

apply_routing() {
  local start='<!-- AI-ROUTING-START -->'
  local end='<!-- AI-ROUTING-END -->'
  local target tmp

  target="$(resolve_routing_target)"

  if [ "$DRY_RUN" -eq 1 ]; then
    log "[dry-run] Would upsert the routing block in ${target}"
    return
  fi

  mkdir -p "$(dirname "$target")"
  touch "$target"

  if grep -qF "$start" "$target" && ! grep -qF "$end" "$target"; then
    echo "Found ${start} without ${end} in ${target}; refusing to edit." >&2
    exit 1
  fi

  if grep -qF "$start" "$target"; then
    tmp="$(mktemp "${target}.XXXXXX")"
    awk -v start="$start" -v end="$end" -v src="${DIR}/routing.md" '
      $0 == start {
        print
        while ((getline line < src) > 0) print line
        close(src)
        skip = 1
        next
      }
      $0 == end { skip = 0 }
      !skip { print }
    ' "$target" > "$tmp"
    mv "$tmp" "$target"
    log "Updated routing block in ${target}"
  else
    {
      printf '\n%s\n' "$start"
      cat "${DIR}/routing.md"
      printf '%s\n' "$end"
    } >> "$target"
    log "Added routing block to ${target}"
  fi
}

resolve_file_target() {
  local target="$1" link
  if [ -L "$target" ]; then
    link="$(readlink "$target")"
    case "$link" in
      /*) target="$link" ;;
      *) target="$(dirname "$target")/$link" ;;
    esac
  fi
  printf '%s\n' "$target"
}

apply_settings() {
  local tmp settings_file

  if [ "$DRY_RUN" -eq 1 ]; then
    log "[dry-run] Would merge ${DIR}/settings.json into ${SETTINGS_FILE}"
    return
  fi

  if [ ! -f "${DIR}/settings.json" ]; then
    echo "-> ${DIR}/settings.json not found; skipping settings merge" >&2
    return 0
  fi

  settings_file="$(resolve_file_target "$SETTINGS_FILE")"
  mkdir -p "$(dirname "$settings_file")"
  [ -f "$settings_file" ] || echo '{}' > "$settings_file"

  if ! jq empty "$settings_file" >/dev/null 2>&1; then
    echo "-> ${settings_file} is not valid JSON; skipping settings merge" >&2
    return 0
  fi

  tmp="$(mktemp "${settings_file}.XXXXXX")"
  if ! jq -s '.[1] * .[0]' "$settings_file" "${DIR}/settings.json" > "$tmp" 2>/dev/null; then
    rm -f "$tmp"
    echo "-> failed to merge settings; leaving ${settings_file} unchanged" >&2
    return 0
  fi
  if ! jq empty "$tmp" >/dev/null 2>&1; then
    rm -f "$tmp"
    echo "-> merged settings are invalid; leaving ${settings_file} unchanged" >&2
    return 0
  fi
  mv "$tmp" "$settings_file"
  log "Applied ${DIR}/settings.json to ${settings_file}"
}

install_hooks() {
  local snippet tmp settings_file

  if [ "$DRY_RUN" -eq 1 ]; then
    log "[dry-run] Would copy hooks to ${HOOKS_DIR} and merge them into ${SETTINGS_FILE}"
    return
  fi

  mkdir -p "$HOOKS_DIR" "$CLAUDE_DIR"
  cp "${DIR}/hooks/scripts/"*.sh "$HOOKS_DIR/"
  chmod +x "${HOOKS_DIR}/"*.sh

  snippet="$(sed "s#__HOOKS_DIR__#${HOOKS_DIR}#g" "${DIR}/hooks/settings.snippet.json")"

  settings_file="$(resolve_file_target "$SETTINGS_FILE")"
  mkdir -p "$HOOKS_DIR" "$(dirname "$settings_file")"
  [ -f "$settings_file" ] || echo '{}' > "$settings_file"

  if ! jq empty "$settings_file" >/dev/null 2>&1; then
    echo "-> ${settings_file} is not valid JSON; skipping hook merge" >&2
    return 0
  fi

  tmp="$(mktemp "${settings_file}.XXXXXX")"
  if ! jq --argjson snippet "$snippet" --arg hooks_dir "$HOOKS_DIR" '
    .hooks = (.hooks // {}) |
    reduce ($snippet.hooks | to_entries[]) as $entry (.;
      .hooks[$entry.key] = (
        ((.hooks[$entry.key] // []) | map(select(
          ((.hooks // []) | map(.command // "") | any(contains($hooks_dir))) | not
        ))) + $entry.value
      )
    )
  ' "$settings_file" > "$tmp"; then
    rm -f "$tmp"
    echo "-> failed to merge hooks; leaving ${settings_file} unchanged" >&2
    return 0
  fi
  if ! jq empty "$tmp" >/dev/null 2>&1; then
    rm -f "$tmp"
    echo "-> merged hooks are invalid; leaving ${settings_file} unchanged" >&2
    return 0
  fi
  mv "$tmp" "$settings_file"
  log "Installed hooks into ${settings_file}"
}

install_plugins
cleanup_legacy_mcp
install_mcp_headers
install_mcp_servers
apply_settings
if [ "$WITH_ROUTING" -eq 1 ]; then
  if link_claude_md; then
    apply_routing
  fi
fi
[ "$WITH_HOOKS" -eq 1 ] && install_hooks

log "Done. Restart Claude Code to load plugins and hooks."
