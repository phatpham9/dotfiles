#!/bin/bash

# ask for the administrator password upfront
sudo -v
# keep-alive: update existing `sudo` time stamp until `macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# install apps
echo "1. Installing apps..."
./apps/install.sh
echo "-> Apps installed!"

# configure apps
echo "2. Configuring apps..."
./configs/install.sh
echo "-> Apps configured!"

# configure macos preferences
echo "3. Configuring MacOS preferences..."
# ./macos/install.sh
echo "-> MacOS preferences configuration skipped!"

# restart
echo "4. Done! Restart your machine to take effect."
