#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# check if running on macOS
is_macos() {
  [[ $(uname) == "Darwin" ]]
}


# xcode
if is_macos; then
  xcode-select --install
  echo "-> xcode installed!"
fi

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "-> brew installed!"

# cli & gui apps by brew
brew bundle --file=${DIR}/cli
if is_macos; then
  brew bundle --file=${DIR}/gui
  echo "-> brew cli & gui apps installed!"
else
  echo "-> brew cli apps installed!"
fi
