<div align="center">
  <h1>dotfiles v2.0</h1>
  <p>Modular dotfiles with profile-based configuration</p>

  <p>
    <a href="https://github.com/phatpham9/dotfiles/commits" aria-label="Commitizen Friendly">
      <img src="https://img.shields.io/badge/commitizen-friendly-brightgreen.svg?style=flat-square">
    </a>
    <a href="https://github.com/phatpham9/dotfiles/blob/master/LICENSE" aria-label="MIT License">
      <img src="https://img.shields.io/github/license/phatpham9/dotfiles?color=brightgreen&style=flat-square">
    </a>
  </p>
</div>

## 🚀 What's New in v2.0

- **Modular Architecture**: Install only what you need
- **Profile System**: Multiple configurations for different contexts
- **Better Error Handling**: Comprehensive logging and recovery
- **Dry Run Mode**: Preview changes before applying
- **Backup System**: Automatic backup of existing configurations
- **Cross-Platform**: Enhanced Linux support
- **Interactive Setup**: Guided installation process

## 📋 Features

- ✅ **Homebrew**: Package management for CLI and GUI applications
- ✅ **Git**: Multi-profile configuration with SSH signing
- ✅ **SSH**: Automated key generation and configuration
- ✅ **Zsh**: Enhanced shell with oh-my-zsh and custom themes
- ✅ **GitHub CLI**: Pre-configured with extensions
- ✅ **Poetry**: Python dependency management
- ✅ **Templates**: Configurable dotfiles with variable substitution

## 🎯 Quick Start

### Simple Installation

```bash
# Clone and install everything with personal profile
git clone https://github.com/phatpham9/dotfiles.git
cd dotfiles
./scripts/install.sh -p personal
```

### Git-free Installation

```bash
mkdir dotfiles && cd dotfiles
curl -#L https://github.com/phatpham9/dotfiles/tarball/master | tar -xzv --strip-components 1
./scripts/install.sh -p personal
```

## 🔧 Advanced Usage

### Profile-based Installation

```bash
# Use personal profile
./scripts/install.sh -p personal

# Use work profile (create your own)
./scripts/install.sh -p work

# Use default configuration
./scripts/install.sh
```

### Selective Module Installation

```bash
# Install only specific modules
./scripts/install.sh -m homebrew,git,ssh

# Install with dry run to preview changes
./scripts/install.sh -n -v

# Force overwrite existing configurations
./scripts/install.sh -f
```

### Command Line Options

```bash
Usage: ./scripts/install.sh [OPTIONS]

OPTIONS:
    -p, --profile PROFILE       Use specific profile (e.g., personal, work)
    -m, --modules MODULES       Comma-separated list of modules to install
    -v, --verbose              Enable verbose output
    -n, --dry-run              Show what would be done without executing
    -f, --force                Force overwrite existing configurations
    -s, --skip-dependencies    Skip system dependency installation
    -h, --help                 Show help message
```

## 📁 Project Structure

```
dotfiles/
├── scripts/                    # New modular installation system
│   ├── install.sh             # Main installer with CLI options
│   ├── lib/                   # Shared utilities
│   │   └── utils.sh          # Common functions and helpers
│   └── modules/               # Individual component modules
│       ├── homebrew.sh       # Homebrew installation
│       ├── git.sh           # Git configuration
│       ├── ssh.sh           # SSH key management
│       ├── zsh.sh           # Zsh configuration
│       ├── gh.sh            # GitHub CLI setup
│       └── poetry.sh        # Poetry configuration
├── configs/                   # Configuration management
│   ├── config.yml            # Central configuration file
│   ├── profiles/             # User profiles
│   │   ├── personal.yml     # Personal profile
│   │   └── work.yml         # Work profile template
│   ├── templates/            # Configuration templates
│   │   └── gitconfig.template
│   ├── git/                  # Git configurations
│   ├── ssh/                  # SSH configurations
│   ├── zsh/                  # Zsh configurations
│   └── gh/                   # GitHub CLI configurations
├── apps/                      # Application management
│   ├── Brewfile_cli         # CLI applications
│   └── Brewfile_gui         # GUI applications
├── install.sh                # Legacy installer (deprecated)
└── README.md                 # This file
```

## 🔨 Creating Custom Profiles

Create a new profile by copying the personal profile:

```bash
cp configs/profiles/personal.yml configs/profiles/work.yml
```

Edit the profile to match your needs:

```yaml
# Work profile configuration
user:
  name: 'Your Name'
  email: 'work@company.com'

ssh:
  keys:
    - name: 'work'
      email: 'work@company.com'
      file: 'id_ed25519_work'

git:
  profiles:
    - name: 'work'
      path: '~/code/work/'
      user_name: 'Your Name'
      user_email: 'work@company.com'
      signing_key: '~/.ssh/id_ed25519_work.pub'
```

## 🛠️ Available Modules

### Homebrew (`homebrew`)

- Installs Homebrew package manager
- Installs CLI and GUI applications from Brewfiles
- Handles platform-specific installation

### Git (`git`)

- Configures Git with signing and multiple profiles
- Sets up conditional includes for different project directories
- Template-based configuration with variable substitution

### SSH (`ssh`)

- Generates SSH keys for different profiles
- Configures SSH client settings
- Sets proper permissions and security

### Zsh (`zsh`)

- Installs and configures oh-my-zsh
- Sets up custom themes and plugins
- Configures shell environment

### GitHub CLI (`gh`)

- Installs and configures GitHub CLI
- Sets up extensions and authentication

### Poetry (`poetry`)

- Configures Poetry for Python development
- Sets up virtual environment preferences

## 🔄 Migration from v1.0

The new system is backward compatible, but for full benefits:

1. **Backup your current setup**: `cp -r configs configs_backup`
2. **Create a profile**: Copy `configs/profiles/personal.yml` and customize
3. **Use the new installer**: `./scripts/install.sh -p your-profile`
4. **Test with dry run**: `./scripts/install.sh -n -v -p your-profile`

## 🐛 Troubleshooting

### Dry Run First

Always test with dry run mode:

```bash
./scripts/install.sh -n -v -p personal
```

### Check Logs

Enable verbose output to see detailed information:

```bash
./scripts/install.sh -v -p personal
```

### Backup Recovery

Restore from automatic backups:

```bash
ls ~/.dotfiles_backup/
cp ~/.dotfiles_backup/file.backup.20231125_143022 ~/original_location
```

### Module-specific Issues

Run individual modules:

```bash
./scripts/modules/git.sh
./scripts/modules/ssh.sh
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Test your changes with: `./scripts/install.sh -n -v`
4. Commit changes: `git commit -m 'Add amazing feature'`
5. Push to branch: `git push origin feature/amazing-feature`
6. Open a Pull Request

## 📖 Documentation

- **Configuration**: See `configs/config.yml` for available options
- **Profiles**: Check `configs/profiles/` for profile examples
- **Modules**: Each module in `scripts/modules/` is self-documented
- **Templates**: Configuration templates in `configs/templates/`

## 🔒 Security

- SSH keys are generated with ed25519 encryption
- Proper file permissions are set automatically
- Backup system prevents data loss
- No sensitive data is stored in the repository

## 📄 License

[MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Phat Pham**

- GitHub: [@phatpham9](https://github.com/phatpham9)
- Email: phat@onroads.xyz

---

<div align="center">
  <p>⭐ Star this repo if it helped you!</p>
  <p>🐛 <a href="https://github.com/phatpham9/dotfiles/issues">Report issues</a> • 🔧 <a href="https://github.com/phatpham9/dotfiles/pulls">Submit PRs</a></p>
</div>
