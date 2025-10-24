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
- **Version Control**: git, gh (GitHub CLI)
- **Shell**: zsh with completions and syntax highlighting
- **Languages & Runtimes**: fnm (Node.js), uv (Python)
- **Containers**: docker, docker-compose, kubectl, kustomize, k3d
- **Infrastructure**: terraform
- **Utilities**: starship (prompt), direnv, jq, yq, bat

**macOS-Specific CLI**:
- colima (container runtime)

**GUI Applications** (macOS only):
- **Browser**: Brave Browser
- **IDE**: Visual Studio Code
- **Database Tools**: Beekeeper Studio, MongoDB Compass, RedisInsight
- **AI Tools**: ChatGPT, LM Studio
- **Microsoft Office**: Word, Excel, PowerPoint
- **Utilities**: Cloudflare WARP, Rectangle, Keka, Kap, IINA, Motrix

### ⚙️ Configurations

The following tools are automatically configured via symlinks:

1. **Zsh** (`.zshrc`, `.zsh_aliases`)
   - Starship prompt theme
   - oh-my-zsh with plugins (git, gh, fnm, npm, uv, docker, kubectl, terraform, direnv)
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

## Installation

### Prerequisites

- **macOS**: Xcode Command Line Tools (installed automatically)
- **Ubuntu**: curl, git, and build-essential (installed automatically)

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
3. Install all applications from `Brewfile_cli` (and `Brewfile_gui` on macOS)
4. Create symlinks for all configuration files
5. Generate SSH keys (if they don't exist)

**Platform Detection:**
- On **macOS**: Installs all CLI and GUI applications
- On **Ubuntu**: Installs CLI applications only, automatically skips macOS-specific packages (colima, all casks)

### Git-Free Installation

Install without cloning via git:

```bash
mkdir dotfiles && cd dotfiles && curl -#L https://github.com/phatpham9/dotfiles/tarball/master | tar -xzv --strip-components 1 && ./install.sh
```

### Post-Installation

After installation completes:
1. Log out and log back in (or restart your terminal)
2. Verify installations: `brew list`
3. Check zsh configuration: `echo $SHELL` (should be `/bin/zsh`)

## Project Structure

```
dotfiles/
├── install.sh              # Main installation script
├── apps/
│   ├── install.sh         # Application installation logic
│   ├── Brewfile_cli       # CLI applications (cross-platform)
│   └── Brewfile_gui       # GUI applications (macOS only)
└── configs/
    ├── install.sh         # Configuration symlink setup
    ├── zsh/              # Zsh configuration
    │   ├── zshrc
    │   └── zsh_aliases
    ├── git/              # Git configuration
    │   ├── gitconfig
    │   └── gitignore_global
    ├── ssh/              # SSH configuration templates
    │   └── config
    ├── gh/               # GitHub CLI configuration
    │   ├── config.yml
    │   └── hosts.yml
    └── docker/           # Docker configuration
        └── config.json
```

## Customization

### Adding New Applications

Edit the appropriate Brewfile:
- `apps/Brewfile_cli` - Add CLI tools with `brew "package-name"`
- `apps/Brewfile_gui` - Add GUI apps with `cask "app-name"` (macOS only)

### Adding New Configurations

1. Add your config files to the appropriate subdirectory under `configs/`
2. Update `configs/install.sh` to create symlinks for your new configs
3. Follow the existing pattern using the `create_symlink` function

### Platform-Specific Packages

To skip a package on Ubuntu, add it to the `HOMEBREW_BUNDLE_BREW_SKIP` variable in `apps/install.sh`:

```bash
HOMEBREW_BUNDLE_BREW_SKIP="colima,other-macos-only-package" brew bundle --file="${DIR}/Brewfile_cli"
```

## Maintenance

### Updating Applications

```bash
# Update Homebrew and upgrade all packages
brew update && brew upgrade

# Or update specific package
brew upgrade <package-name>
```

### Updating Configurations

Since configs are symlinked, simply pull the latest changes:

```bash
cd dotfiles
git pull
```

Changes take effect immediately (you may need to restart your shell for some changes).

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
