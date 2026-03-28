# Copilot Instructions

This is a macOS/Ubuntu dotfiles framework that provisions a full development environment via Homebrew, config symlinks, and profile-based multi-account support.

## Architecture

Three-layer installation pipeline, each layer delegating to sub-installers:

```
install.sh
├── apps/install.sh          # Install packages (Homebrew, CLI, GUI, oh-my-zsh)
│   ├── apps/cli/install.sh  # brew bundle (cross-platform)
│   └── apps/gui/install.sh  # brew bundle (macOS-only)
└── configs/install.sh       # Create all config symlinks
    ├── configs/ssh/
    ├── configs/git/
    ├── configs/gh/
    ├── configs/docker/
    ├── configs/zsh/
    ├── configs/starship/
    └── configs/ai-agents/   # Symlinks to ~/.agents, ~/.copilot, ~/.gemini
```

**Profile management** (`add_profile.sh` / `remove_profile.sh`): Creates per-account Git/SSH configs. Profile names are normalized to snake_case. Template files use `[profile]`, `[your-name]`, `[your-email]` placeholders. Git uses `includeIf "gitdir:~/code/[profile]/"` to activate the right identity per directory.

**Config symlink pattern**: Each `configs/*/install.sh` symlinks tracked source files into `~` or `~/.config`. Edits to the symlink targets are immediately effective and git-tracked.

**AI agents layer** (`configs/ai-agents/`): Symlinks skills/agents to three destinations simultaneously — `~/.agents/skills`, `~/.copilot/agents`, and `~/.gemini/antigravity/skills`.

## Shell Scripting Conventions

Every script follows this structure:

```bash
#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${DIR}/../../utils/is_macos.sh"
source "${DIR}/../../utils/create_symlink.sh"
```

**Key patterns:**
- `set -e` in every script — exit on first error
- `DIR` computed via `${BASH_SOURCE[0]}` — always use absolute paths for `source`
- Platform detection via `is_macos()` from `utils/is_macos.sh` (`[[ $(uname) == "Darwin" ]]`)
- Idempotent operations — check with `[ ! -f ]` / `[ ! -d ]` before creating files or keys
- Variables always quoted as `"${VAR}"`, command substitution as `$(...)`
- `sed -i ''` (BSD sed, macOS-compatible empty string arg)
- Output: `echo "-> Description"` prefix convention for status messages
- macOS-only packages skipped on Ubuntu via `HOMEBREW_BUNDLE_BREW_SKIP="colima macmon"`

**Shared utilities** in `utils/`:
- `is_macos.sh` — platform check
- `create_symlink.sh` — `ln -sf` wrapper with echo
- `generate_ssh_key.sh` — idempotent ed25519 key generation
- `to_snake_case.sh` — normalizes profile names

## Testing

No automated tests. Manual testing via Docker:

```bash
docker run -d --name dotfiles-test -v $(pwd):/root/dotfiles ubuntu:latest tail -f /dev/null
docker exec dotfiles-test bash -c "cd /root/dotfiles && ./install.sh"
docker rm -f dotfiles-test
```

## Commits

Follow [Commitizen](https://commitizen-tools.github.io/commitizen/) conventional commits: `type(scope): description`.

## Engineering Standards

Core standards for code in this repo (and projects it configures) are defined in `configs/ai-agents/rules.md`. Key points: TypeScript strict mode, Next.js RSC by default, NestJS feature modules, OWASP security defaults, multi-stage Docker, semantic versioning.
