<div align="center">
  <h1>dotfiles</h1>
  <p>🚀 Automated development environment setup for macOS and Ubuntu</p>

  <p>
    <a href="https://github.com/phatpham9/dotfiles/commits" aria-label="Commitizen Friendly">
      <img src="https://img.shields.io/badge/commitizen-friendly-brightgreen.svg?style=flat-square">
    </a>
    <a href="https://github.com/phatpham9/dotfiles/blob/master/LICENSE" aria-label="MIT License">
      <img src="https://img.shields.io/github/license/phatpham9/dotfiles?color=brightgreen&style=flat-square">
    </a>
  </p>
</div>

## Overview

A fully automated dotfiles repository that sets up a complete development environment in minutes. This repository manages application installation, configuration files, and environment setup with intelligent cross-platform support.

## Concepts

- **⚡ Fast Setup**: Get a fully configured dev environment in minutes, not hours
- **🌍 Cross-Platform**: Full support for **macOS** and **Ubuntu** with intelligent platform detection
- **📦 Homebrew-Based**: Uses Homebrew for all package management, making upgrades and uninstalls simple
- **🔗 Symlink Management**: Configuration files are symlinked, allowing easy updates via git
- **🎯 Platform-Aware**: Automatically skips incompatible packages (e.g., colima on Ubuntu, GUI apps on servers)

## What's Included

### 📱 Applications

**CLI Tools** (Both macOS & Ubuntu):

- **Version Control**: git, git-lfs, gh (GitHub CLI)
- **Shell**: zsh with completions and syntax highlighting
- **Languages & Runtimes**: fnm (Node.js), go, rust, uv (Python)
- **Containers**: docker, docker-compose, kubectl, k3d
- **Infrastructure**: opentofu
- **Secrets Management**: sops
- **Cloud** (commented out by default; uncomment in `apps/cli/Brewfile` to enable): awscli, gcloud-cli, azure-cli, tailscale
- **AI/ML Tools**: CodeGraph CLI, hf (Hugging Face CLI), OpenViking, MarkItDown
- **Language Servers & Linters**: gopls (Go), rust-analyzer (Rust), golangci-lint, tofu-ls (OpenTofu)
- **Utilities**: starship (prompt), direnv, jq, yq, bat, ripgrep, ffmpeg

**macOS-Specific CLI**:

- colima (container runtime)
- macmon (system monitoring)
- omlx (Apple Silicon LLM inference server, via the `jundot/omlx` tap)

**GUI Applications** (macOS only):

- **Browser**: Helium Browser, Google Chrome
- **IDE**: Visual Studio Code
- **AI/ML Tools**: Claude Code, Codex, Hermes Desktop, oMLX App (desktop)
- **Research & Paper Writing**: Quarto, Zotero
- **Office**: Word, Excel, PowerPoint
- **Knowledge Management**: Obsidian
- **Virtualization**: UTM
- **Utilities**: Cloudflare WARP, Rectangle, Keka, IINA, Motrix, Itsycal, CoconutBattery, Homebrew

### ⚙️ Configurations

The following tools are automatically configured:

1. **Zsh** (`.zshrc`, `.zsh_aliases`)
   - Starship prompt theme

- oh-my-zsh with plugins (git, gh, fnm, npm, uv, docker, kubectl, opentofu, direnv)
- Platform-specific Homebrew initialization
- fnm auto-switching on directory change

2. **Git** (`.gitconfig`, `.gitignore_global`)
   - SSH-based GPG signing
   - Auto-setup remote branches on push
   - Case-sensitive file handling
   - Commit/tag signing enabled
   - Branch sorting by commit date

3. **SSH** (`~/.ssh/config`)
   - Automatic SSH key generation (ed25519)
   - Dual SSH key support for multiple SSH accounts

4. **GitHub CLI** (`~/.config/gh/`)
   - Pre-configured gh settings

5. **Docker** (`~/.docker/config.json`)
   - Custom Docker daemon settings

6. **Starship** (`~/.config/starship.toml`)
   - Cross-shell prompt configuration

7. **AI (Claude Code)** (`configs/ai`)
   - Installs the Superpowers and Matt Pocock skill plugins from the official Claude Code marketplace
   - Adds companion plugins (`frontend-design`, `typescript-lsp`, `claude-md-management`, `security-guidance`, `hookify`)
   - Adds subagent packs: `pr-review-toolkit`, `claude-security`, and selected `wshobson/agents` domain plugins (TypeScript, Python, Go/Rust, security, Kubernetes, observability, Terraform/cloud)
   - Adds language servers: `gopls-lsp`, `rust-analyzer-lsp`, and a local `tofu-ls` LSP plugin
   - Configures MCP servers from `configs/ai/mcp.json` (GitHub and Hugging Face via header-helper scripts that reuse the `gh`/`hf` CLI logins; Chrome DevTools via `npx`) plus the Context7 and Playwright MCP plugins
   - Symlinks `configs/ai/CLAUDE.md` to `~/.claude/CLAUDE.md` and upserts the skill and agent routing block
   - Optional `--with-hooks` adds guardrail, formatting, and TypeScript verification hooks
   - **CodeGraph CLI** (`codegraph`): installed by `apps/cli/install.sh` via the upstream installer and used for local code graph indexing and MCP serving

8. **OpenViking** (`~/.openviking`)
   - CLI config (`ovcli.conf`, `ovcli.settings.conf`) symlinked from `configs/openviking`
   - `openviking-server` launch agent (`ai.openviking.server`) on macOS
   - `ingest.json` is merged into `ov.conf` to replay Claude Code session logs, and the `ai.openviking.ingest` launch agent backfills then watches for changes
   - `ov.conf` holds provider API keys, is created locally with `ov config`, and is not tracked by this repo
   - Check ingest progress with `openviking-server ingest status`

## Installation

### Prerequisites

- **macOS**: Xcode Command Line Tools (installed automatically)
- **Ubuntu**: curl, git, zsh, and build-essential (installed automatically)

### Quick Start

Clone the repository and run the installation script:

```bash
git clone https://github.com/phatpham9/dotfiles.git
cd dotfiles
./install.sh
```

The installation script will:

1. Request sudo password (required for system-level changes)
2. Install Homebrew (if not already installed)
3. Install CLI applications from `apps/cli/Brewfile`, then install uv tools (OpenViking, MarkItDown), `tofu-ls`, and CodeGraph CLI (and `apps/gui/Brewfile` on macOS)
4. Install oh-my-zsh (if not already installed)
5. Create symlinks for configuration files and install the Claude Code AI stack
6. Generate SSH keys (if they don't exist)

**Platform Detection:**

- On **macOS**: Installs all CLI and GUI applications
- On **Ubuntu**: Installs CLI applications only, automatically skips macOS-specific packages (colima, macmon, omlx, and all casks)

### Git-Free Installation

Install without cloning via git:

```bash
mkdir dotfiles && cd dotfiles && curl -#L https://github.com/phatpham9/dotfiles/tarball/master | tar -xzv --strip-components 1 && ./install.sh
```

### Testing with Docker

You can test the installation in a clean Ubuntu environment using Docker:

```bash
# Start Ubuntu container with project mounted
docker run -d --name dotfiles-test -v $(pwd):/root/dotfiles ubuntu:latest tail -f /dev/null

# Install prerequisites
docker exec dotfiles-test apt-get update
docker exec dotfiles-test apt-get install -y sudo curl git

# Run installation
docker exec -it dotfiles-test bash -c "cd /root/dotfiles && ./install.sh"

# Clean up when done
docker rm -f dotfiles-test
```

### Post-Installation

After installation completes:

1. Log out and log back in (or restart your terminal)
2. Verify installations: `brew list`
3. Check zsh configuration: `echo $SHELL` (should be `/bin/zsh`)
4. Verify Claude Code setup (macOS): `claude plugin list` and `claude mcp list`

## Profile Management

Manage multiple Git/SSH profiles for different projects or organizations (e.g., personal, work, client projects).

### Adding a New Profile

Use the `add_profile.sh` script to create a new profile:

```bash
./add_profile.sh
```

The script will:

1. Prompt for profile name, Git user.name, and Git user.email
2. Convert the profile name to snake_case automatically
3. Generate a new SSH key (`~/.ssh/id_ed25519_[profile]`)
4. Create profile-specific SSH config (`configs/ssh/config_[profile]`)
5. Create profile-specific Git config (`configs/git/gitconfig_[profile]`)
6. Set up symlinks for both configs
7. Add an `includeIf` directive to the main `.gitconfig`

**After running the script:**

1. Add the SSH public key to your Git hosting service:
   ```bash
   cat ~/.ssh/id_ed25519_[profile].pub
   ```
2. Create a directory for profile projects: `~/code/[profile]/`
3. Any Git repositories under `~/code/[profile]/` will automatically use the profile's Git config

### Removing a Profile

Use the `remove_profile.sh` script to remove an existing profile:

```bash
./remove_profile.sh
```

The script will:

1. Prompt for the profile name to remove
2. Display all files and configurations that will be deleted
3. Ask for confirmation before proceeding
4. Remove SSH keys, SSH config, Git config, symlinks, and the `includeIf` directive

**Warning:** This operation cannot be undone. Make sure to backup any important data before removal.

## Project Structure

```
dotfiles/
├── apps/
│   ├── cli/
│   │   ├── install.sh
│   │   ├── upgrade.sh           # Upgrade CodeGraph, OpenViking, MarkItDown
│   │   └── Brewfile             # CLI applications (cross-platform)
│   ├── gui/
│   │   ├── install.sh
│   │   └── Brewfile             # GUI applications (macOS only)
│   └── install.sh               # Application installation logic
├── configs/
│   ├── ai/                      # Claude Code plugins, MCP, LSP, routing, hooks
│   │   ├── install.sh
│   │   ├── upgrade.sh
│   │   ├── plugins.txt
│   │   ├── plugins.optional.txt
│   │   ├── mcp.json
│   │   ├── CLAUDE.md            # Symlinked to ~/.claude/CLAUDE.md
│   │   ├── routing.md
│   │   ├── lsp/                 # Local ai-lsp marketplace (tofu-ls)
│   │   ├── mcp-headers/         # MCP header-helper scripts (gh/hf auth)
│   │   └── hooks/
│   ├── docker/                  # Docker configuration
│   │   ├── install.sh
│   │   └── config.json
│   ├── gh/                      # GitHub CLI configuration
│   │   ├── install.sh
│   │   ├── config.yml
│   │   └── hosts.yml
│   ├── git/                     # Git configuration
│   │   ├── install.sh
│   │   ├── gitconfig
│   │   ├── gitconfig_[profile]  # Profile-specific Git config template
│   │   └── gitignore_global
│   ├── openviking/              # OpenViking CLI and server configuration
│   │   ├── install.sh
│   │   ├── ingest.json
│   │   ├── ovcli.conf
│   │   ├── ovcli.settings.conf
│   │   ├── ai.openviking.server.plist.template
│   │   └── ai.openviking.ingest.plist.template
│   ├── ssh/                     # SSH configuration
│   │   ├── install.sh
│   │   ├── config
│   │   └── config_[profile]     # Profile-specific SSH config template
│   ├── starship/                # Starship configuration
│   │   ├── install.sh
│   │   └── starship.toml
│   ├── zsh/                     # Zsh configuration
│   │   ├── install.sh
│   │   ├── zshrc
│   │   └── zsh_aliases
│   └── install.sh               # Configuration symlink setup
├── utils/                       # Utility functions
│   ├── is_macos.sh              # macOS detection helper
│   ├── create_symlink.sh        # Symlink creation helper
│   ├── generate_ssh_key.sh      # SSH key generation helper
│   └── to_snake_case.sh         # String to snake_case converter
├── .gitignore                   # Git ignore rules
├── AGENTS.md                    # Repo-scoped guidance for coding agents
├── add_profile.sh               # Add new Git/SSH profile
├── install.sh                   # Main installation script
├── LICENSE                      # MIT License
└── remove_profile.sh            # Remove existing Git/SSH profile
```

## Customization

### Adding New Applications

Edit the appropriate Brewfile:

- `apps/cli/Brewfile` - Add CLI tools with `brew "package-name"`
- `apps/gui/Brewfile` - Add GUI apps with `cask "app-name"` (macOS only)

The current exceptions are CodeGraph CLI (upstream installer), OpenViking (`openviking[local-embed]`) and MarkItDown (`markitdown[all]`) as uv tools, `tofu-ls` (checksum-verified GitHub Releases archive), and the oMLX desktop app (upstream dmg) — all installed by `apps/cli/install.sh` or `apps/gui/install.sh`. Go, gopls, rust-analyzer, and golangci-lint are Brewfile formulae.

### Adding New Configurations

1. Add your config files to the appropriate subdirectory under `configs/`
2. Update `configs/install.sh` to create symlinks for your new configs
3. Follow the existing pattern using the `create_symlink` function

### Platform-Specific Packages

To skip a package on Ubuntu, add it to the `HOMEBREW_BUNDLE_BREW_SKIP` variable in `apps/cli/install.sh`:

```bash
HOMEBREW_BUNDLE_BREW_SKIP="colima macmon omlx" brew bundle --file="${DIR}/Brewfile"
```

## Maintenance

### Updating Applications

```bash
# Update Homebrew and upgrade all packages
brew update && brew upgrade

# Or update specific package
brew upgrade <package-name>
```

### Upgrading Non-Homebrew Tools

```bash
# Upgrade CodeGraph, OpenViking, and MarkItDown
./apps/cli/upgrade.sh

# Upgrade Claude Code plugins and marketplaces
./configs/ai/upgrade.sh

# Refresh tofu-ls (re-runs the checksum-verified release install)
./apps/cli/install.sh
```

### Updating Configurations

Since configs are symlinked, simply pull the latest changes:

```bash
cd dotfiles
git pull
```

Changes take effect immediately (you may need to restart your shell for some changes). For Claude Code plugins and marketplaces, also run `./configs/ai/upgrade.sh` after pulling.

## Troubleshooting

### Homebrew Not Found After Installation

Add Homebrew to your PATH manually:

```bash
# macOS
eval "$(/opt/homebrew/bin/brew shellenv)"

# Ubuntu
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### Permission Errors

Ensure you have proper permissions and sudo access:

```bash
sudo -v
```

### Symlink Conflicts

If symlinks fail due to existing files, back them up first:

```bash
mv ~/.zshrc ~/.zshrc.backup
```

Then re-run the installation.

### Claude Code CLAUDE.md Not Linked

If `~/.claude/CLAUDE.md` already exists as a regular file, `configs/ai/install.sh` leaves it untouched. Back it up, then re-run the AI installer:

```bash
mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup
./configs/ai/install.sh
```

## Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes using [Commitizen](https://commitizen.github.io/cz-cli/) (`git cz`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

Please ensure your changes:

- Work on both macOS and Ubuntu (or use platform detection)
- Follow the existing code style
- Include appropriate comments
- Don't break existing functionality

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Phat Pham**

- GitHub: [@phatpham9](https://github.com/phatpham9)
- Email: phat@onroads.xyz
- Website: [onroads.xyz](https://onroads.xyz)

## Acknowledgments

- [Homebrew](https://brew.sh/) - The missing package manager for macOS (and Linux)
- [oh-my-zsh](https://ohmyz.sh/) - Framework for managing Zsh configuration
- [Starship](https://starship.rs/) - Cross-shell prompt

---

<div align="center">
  Made with ❤️ by <a href="https://github.com/phatpham9">Phat Pham</a>
</div>
