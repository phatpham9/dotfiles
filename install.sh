#!/bin/bash
# This script creates symlinks from the home directory to any desired dotfiles

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES="zshrc gitconfig gitignore_global"

for FILE in ${FILES}; do
  echo "Creating symlink to ${FILE} in home directory..."
  ln -s ${DIR}/${FILE} ~/.${FILE}
done

echo "-> Done!"
