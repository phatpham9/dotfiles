#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# zsh
ln -sf ${DIR}/zsh/zshrc ~/.zshrc
echo "-> zsh configured!"

# ssh
ssh-keygen -t ed25519 -C "phat@onroads.xyz" -f "${HOME}/.ssh/id_ed25519" -P ""
ssh-keygen -t ed25519 -C "phatttpham9@gmail.com" -f "${HOME}/.ssh/id_ed25519_secondary" -P ""
ssh-keygen -t ed25519 -C "phat.pham@setel.com" -f "${HOME}/.ssh/id_ed25519_setel" -P ""
ln -sf ${DIR}/ssh/config ~/.ssh/config
ln -sf ${DIR}/ssh/config_secondary ~/.ssh/config_secondary
ln -sf ${DIR}/ssh/config_setel ~/.ssh/config_setel
echo "-> ssh key generated & configured!"
echo "-> Attention! Don't forget to copy the public key & add it to remote hosts such as github.com & gitlab.com."

# git
ln -sf ${DIR}/git/gitconfig ~/.gitconfig
ln -sf ${DIR}/git/gitconfig_secondary ~/.gitconfig_secondary
ln -sf ${DIR}/git/gitconfig_setel ~/.gitconfig_setel
ln -sf ${DIR}/git/gitignore_global ~/.gitignore_global
echo "-> git configured!"

# change the default shell to zsh
chsh -s $(which zsh)
