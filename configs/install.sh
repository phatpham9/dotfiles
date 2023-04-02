#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# zsh
ln -sf ${DIR}/zsh/zshrc ~/.zshrc
echo "-> zsh configured!"

# gpg
gpg --batch --generate-key "gpg/generate-key"
gpg --armor --export phat@onroads.xyz
gpg --batch --generate-key "gpg/generate-key_setel"
gpg --armor --export phat.pham@setel.com
echo "-> gpg key generated!"
echo "-> Attention! Don't forget to copy the public key & add it to remote hosts such as github.com & gitlab.com."

# ssh
ssh-keygen -t ed25519 -C "phat@onroads.xyz" -f "${HOME}/.ssh/id_ed25519" -P ""
ssh-keygen -t ed25519 -C "phat.pham@setel.com" -f "${HOME}/.ssh/id_ed25519_setel" -P ""
ln -sf ${DIR}/ssh/config ~/.ssh/config
echo "-> ssh key generated & configured!"
echo "-> Attention! Don't forget to copy the public key & add it to remote hosts such as github.com & gitlab.com."

# git
ln -sf ${DIR}/git/gitconfig ~/.gitconfig
ln -sf ${DIR}/git/gitconfig_setel ~/.gitconfig_setel
ln -sf ${DIR}/git/gitignore_global ~/.gitignore_global
keys=($(gpg --list-keys --keyid-format LONG | grep -E -o -m 2 "ed25519/[0-9A-F]{16}" | grep -E -o -m 2 "[0-9A-F]{16}"))
git config --file ~/.gitconfig user.signingkey $keys[1]
git config --file ~/.gitconfig_setel user.signingkey $keys[2]
echo "-> git configured!"
echo "-> Attention! Git config \"user.signingkey\" has been updated. Don't forget to commit & push your changes to remote repository."

# brave
echo "-> brave configuration skipped! Manual works needed for now."
