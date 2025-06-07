<div align="center">
  <h1>dotfiles</h1>
  <p>My dotfiles for dev environment</p>

  <p>
    <a href="https://github.com/phatpham9/dotfiles/commits" aria-label="Commitizen Friendly">
      <img src="https://img.shields.io/badge/commitizen-friendly-brightgreen.svg?style=flat-square">
    </a>
    <a href="https://github.com/phatpham9/dotfiles/blob/master/LICENSE" aria-label="MIT License">
      <img src="https://img.shields.io/github/license/phatpham9/dotfiles?color=brightgreen&style=flat-square">
    </a>
  </p>
</div>

## Concepts

- Setup new dev environment in minutes not hours
- Cross-platform support for **macOS** and **Ubuntu**
- Use `bash` to run installation commands but `zsh` will be the main shell
- Use `homebrew` to install all CLI/GUI applications as it's easier to upgrade/uninstall the apps
- Platform-specific package handling (e.g., colima is only installed on macOS)

## Features

This repo contains the automatic installation/configuration of the following steps:

1. [x] Install applications (`homebrew`) with platform-specific handling
2. [x] Configure applications by creating symlinks (`zsh`, `ssh` & `git`)

**Platform Support:**

- **macOS**: Full installation including all CLI and GUI applications
- **Ubuntu**: CLI applications only, with macOS-specific packages automatically skipped

## Installation

**Supported Platforms:** macOS and Ubuntu

Clone the repo then simply run the following command:

```bash
./install.sh
```

The script will automatically detect your platform and:

- On **macOS**: Install all CLI and GUI applications
- On **Ubuntu**: Install CLI applications only, skipping macOS-specific packages like `colima`

### Git-free Installation

Download the repository's tarball by running:

```bash
mkdir dotfiles && cd dotfiles && curl -#L https://github.com/phatpham9/dotfiles/tarball/master | tar -xzv --strip-components 1 && ./install.sh
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Authors

[Phat Pham](https://github.com/phatpham9)

## License

[MIT](https://github.com/phatpham9/dotfiles/blob/master/LICENSE)
