<div align="center">
  <h1>dotfiles</h1>
  <p>My dotfiles setup automation</p>

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

- Setup new dev machine in minutes not hours
- Use `bash` to run installation commands but `zsh` will be the main shell after all
- Use `homebrew` to install all GUI/CLI applications, it's easier to upgrade or uninstall the apps later

## Features

This repo contains the automatic installation/configuration of the following steps:

1. [x] Install applications (`brew`/`cask` apps, `nvm` node binaries, `npm` global packages & `vscode` extensions)
2. [x] Configure applications by creating symlinks (`zsh`, `ssh`, `git`, `docker`, `minukube` & `vscode`)
3. [ ] Configure `macos` preferences

## Installation

Clone the repo then simply run the following command:

```bash
./install.sh
```

### Git-free Installation

Download the repository's tarball by running:

```bash

curl -#L https://github.com/phatpham9/dotfiles/tarball/master | tar -xzv --strip-components 1 && ./install.sh
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Authors

[Phat Pham](https://github.com/phatpham9)

## License

[MIT](https://github.com/phatpham9/dotfiles/blob/master/LICENSE)
