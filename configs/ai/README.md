# AI Stack (Claude Code)

Staged Claude Code setup built around **Superpowers + Matt Pocock skills**, a
skill-routing rule, focused companion plugins, custom hooks, and the MCP servers
from the previous MCP configuration.

> **Status: applied.** `configs/install.sh` calls `configs/ai/install.sh`, and
> the core stack is installed on this workstation. Optional plugins and hooks
> remain opt-in via `--with-optional` and `--with-hooks`.

## Layout

| Path | Purpose |
|---|---|
| `plugins.txt` | Required plugins (skills, companions, subagent packs, LSP/MCP plugins) |
| `plugins.optional.txt` | Optional AI/ML, authoring, and writing plugins |
| `mcp.json` | MCP servers installed at user scope (the ones not shipped as official plugins) |
| `settings.json` | User-scope Claude Code settings merged into `~/.claude/settings.json` (default model) |
| `CLAUDE.md` | User-level Claude Code instructions, symlinked to `~/.claude/CLAUDE.md` |
| `routing.md` | Skill and agent routing block upserted into `CLAUDE.md` |
| `hooks/settings.snippet.json` | Hook definitions merged into `~/.claude/settings.json` |
| `hooks/scripts/` | Hook scripts copied to `~/.claude/hooks/ai/` |
| `lsp/` | Local `ai-lsp` marketplace with the `tofu-ls` LSP plugin |
| `mcp-headers/` | Header-helper scripts copied to `~/.local/bin/` for token-based MCP auth |
| `install.sh` | Idempotent installer (supports `--dry-run`) |
| `upgrade.sh` | Updates the installed plugins/marketplaces |

## What gets installed

### Skills (core)

- `superpowers@claude-plugins-official` — brainstorming, plans, subagent-driven
  execution, strict TDD, systematic debugging, review loops.
- `mattpocock-skills@claude-plugins-official` — grilling, specs, tickets,
  triage, domain modelling, TDD, code review, PR flow.

Both are installed; `routing.md` decides which skill handles which stage.

### Companions

- `frontend-design` — UI quality for Next.js/React work.
- `typescript-lsp` — TypeScript/Next.js/NestJS code intelligence.
- `claude-md-management` — maintain the routing rule and project `CLAUDE.md`.
- `security-guidance` — fintech/compliance-oriented security checks (opt-in
  behavior; adds edit/Stop hook latency).
- `hookify` — author and adjust the hooks below.

Deliberately **not** installed because they overlap Superpowers/Matt:
`code-review`, `feature-dev`, `code-simplifier`, `commit-commands`.

### Subagent packs

- `pr-review-toolkit` — 6 reviewers plus `/pr-review-toolkit:review-pr`:
  `code-reviewer`, `silent-failure-hunter`, `pr-test-analyzer`,
  `type-design-analyzer`, `comment-analyzer`, `code-simplifier`.
- `claude-security` — the `claude-security:claude-security` skill plus 9
  scan/orchestration agents for full security scans.
- `wshobson/agents` (`claude-code-workflows` marketplace), selected domain
  packs. Some agents carry a doubled plugin prefix; these are the exact
  registered names:
  - `javascript-typescript` — `javascript-pro`, `typescript-pro`
  - `python-development` — `python-pro`,
    `python-development-fastapi-pro`, `python-development-django-pro`
  - `security-scanning` — `security-scanning-security-auditor`,
    `threat-modeling-expert`
  - `kubernetes-operations` — `kubernetes-operations-kubernetes-architect`
  - `observability-monitoring` —
    `observability-monitoring-observability-engineer`,
    `observability-monitoring-performance-engineer`,
    `observability-monitoring-database-optimizer`,
    `observability-monitoring-network-engineer`
  - `systems-programming` — `golang-pro`, `rust-pro` (plus `c-pro`/`cpp-pro`)
  - `cloud-infrastructure` —
    `cloud-infrastructure-terraform-specialist`,
    `cloud-infrastructure-cloud-architect`,
    `cloud-infrastructure-deployment-engineer`,
    `hybrid-cloud-architect`, `cloud-infrastructure-kubernetes-architect`,
    `cloud-infrastructure-network-engineer`, `service-mesh-expert`

### Language servers

- `gopls-lsp` — Go intelligence; requires `gopls`.
- `rust-analyzer-lsp` — Rust intelligence; requires `rust-analyzer`.
- `tofu-ls` — OpenTofu `.tf`/`.tofu`/`.tfvars` intelligence, installed from the
  local `ai-lsp` marketplace (`configs/ai/lsp`); requires `tofu-ls`.

Toolchain (installed by `apps/cli`): `go`, `gopls`, `rust-analyzer`,
`golangci-lint`, and `tofu-ls` from the upstream GitHub Releases archive into
`~/.local/bin` (checksum-verified; `go install` does not work because its
`go.mod` uses replace directives).

### Optional (`--with-optional`)

- `pyright-lsp`, `huggingface-skills` — AI/ML Python work.
- `skill-creator` — authoring skills with evals (`plugin-dev` is the commented
  alternative).
- `elements-of-style`, `superpowers-developing-for-claude-code` — writing and
  plugin-development references from the Superpowers marketplace.

### MCP servers

Two are provided by official plugins (one source per server, no user-scope
duplicates):

| Server | Source |
|---|---|
| `context7` | `context7@claude-plugins-official` |
| `playwright` | `playwright@claude-plugins-official` |

Nine are installed at **user scope** from `mcp.json`:

| Server | Notes |
|---|---|
| `arxiv-mcp-server` | `uv tool run`; storage under `~/.cache/arxiv-mcp-server` |
| `bgpt` | Remote SSE; 50 free results per network |
| `chrome-devtools` | `npx -y chrome-devtools-mcp@latest` |
| `codegraph` | Requires `codegraph` on PATH; `apps/cli/install.sh` installs it |
| `deepwiki` | Remote HTTP |
| `github` | Auth via `mcp-headers/github-mcp-auth.sh` → `gh auth token` (keyring) |
| `markitdown` | `uvx markitdown-mcp`; install the CLI with `uv tool install 'markitdown[all]'` |
| `next-devtools` | `npx -y next-devtools-mcp@latest` |
| `openviking` | Requires `openviking-server` running on `127.0.0.1:1933` |

The optional `huggingface-skills` plugin supplies the Hugging Face MCP server;
it is not duplicated in `mcp.json`.

`markitdown-ocr-mcp` is not managed by this config and is left untouched.

The `github` server authenticates through the `headersHelper` script in
`mcp-headers/` (deployed to `~/.local/bin/` by `install.sh`) that reads the `gh`
CLI token at connect time — no token is stored in this repo or in
`~/.claude.json`.

### Settings

`settings.json` holds user-scope Claude Code settings that are not plugin or
hook related. `install.sh` merges it into `~/.claude/settings.json` on every
run as defaults: keys already present in `~/.claude/settings.json` take
precedence, so a model chosen with `/model` or `/config` is preserved.
Currently the tracked default is `"model": "sonnet"`.

### Routing rule

`configs/ai/CLAUDE.md` is the tracked user-level Claude Code memory.
`install.sh` links `~/.claude/CLAUDE.md` to it when the target is absent, then
upserts the block from `routing.md` between `<!-- AI-ROUTING-START -->` and
`<!-- AI-ROUTING-END -->` through the symlink. It includes both
`## Skill routing` and `## Agent routing`.

If `~/.claude/CLAUDE.md` is a regular file or a symlink to another path, the
installer leaves it untouched. Use `--no-routing` to skip both the link and the
update.

### Hooks (`--with-hooks`)

Scripts are copied to `~/.claude/hooks/ai/` and merged into
`~/.claude/settings.json`:

| Hook | Event | Effect |
|---|---|---|
| `guard-dangerous-commands.sh` | `PreToolUse` (`Bash`) | Blocks destructive commands (`rm -rf /`, force-push, namespace/PV deletes, `terraform`/`tofu apply -auto-approve`, `DROP DATABASE`) |
| `protect-secrets.sh` | `PreToolUse` (`Edit\|Write\|MultiEdit`) | Blocks edits to `.env*` (except examples), keys, `.ssh`, `.aws`, `.config/gh/hosts.yml`, Hugging Face tokens, `.claude/.credentials.json`, gcloud/container auth, `.docker/config.json`, `.kube/config`, `.npmrc`, `.envrc` |
| `format-edited-files.sh` | `PostToolUse` (`Edit\|Write\|MultiEdit`) | Runs project-local Prettier then ESLint on supported files |
| `verify-typescript.sh` | `Stop` | Runs the project's `typecheck` script (or local `tsc --noEmit`); optional tests via `AI_HOOK_RUN_TESTS=1` |

Disable a hook at runtime with `AI_HOOK_VERIFY=0` or `AI_HOOK_FORMAT=0`; remove
the corresponding entry from `~/.claude/settings.json` to remove it entirely.

## Usage

Review first, then run when ready:

```bash
# show every action without changing anything
./configs/ai/install.sh --dry-run

# core skills + companions + MCP + routing
./configs/ai/install.sh

# everything, including optional plugins and hooks
./configs/ai/install.sh --all
```

| Flag | Effect |
|---|---|
| `--with-optional` | Install `plugins.optional.txt` |
| `--with-hooks` | Install hook scripts and merge them into `~/.claude/settings.json` |
| `--no-routing` | Skip linking and updating `~/.claude/CLAUDE.md` |
| `--all` | `--with-optional --with-hooks` |
| `--dry-run` | Print actions without executing them |

The installer is idempotent: marketplaces and plugins already present exit 0,
and MCP entries are removed then re-added under the same names. It replaces
existing **user-scope** MCP entries with the names above; it does not touch
project-scope `.mcp.json` files.

## Upgrade

```bash
./configs/ai/upgrade.sh
```

Refreshes all configured marketplaces (official, Superpowers, wshobson, and the
local `ai-lsp` marketplace) and updates every installed plugin from both lists.
MCP servers fetched by `npx`/`uvx` resolve on demand; `codegraph`, `openviking`,
and `markitdown` are upgraded by `apps/cli/upgrade.sh`. Re-run
`apps/cli/install.sh` to refresh `tofu-ls`.

## Manual cleanup (not done by the installer)

If you want to stop loading the pre-plugin Claude Code artifacts:

```bash
rm -f ~/.claude/skills          # old shared skills symlink
rm -f ~/.claude/agents/*.md     # old copied agents
```

The previous AI configuration directory has been removed from this repo; the commands above are only for machines that still have the old symlinks.

## Environment

- `CONTEXT7_API_KEY` — optional; higher Context7 rate limits.
- GitHub MCP auth reuses the `gh` CLI login via the `mcp-headers/` helper
  script; no API token is stored in config or this repo. Hugging Face is
  provided by the optional `huggingface-skills` plugin.
- No secrets are stored in this directory.

## Context budget

Both skill plugins cost roughly 1,700 tokens/turn plus ~570 tokens of
Superpowers startup context. The user-level `CLAUDE.md` adds roughly 2.5k
tokens per session. The five companions and the subagent packs add their
descriptions on every turn; install optional packs only while actively doing
that work. LSP plugins add no model-context cost. Individual plugin
skills/agents cannot be disabled — disable a whole plugin with
`claude plugin disable <plugin>` if the stack becomes noisy.
