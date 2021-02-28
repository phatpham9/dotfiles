#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Install apps
echo '1. Installing apps...'
./apps/install.sh
echo '-> Apps installed!'

# Config apps
echo '2. Configuring apps...'
./configs/install.sh
echo '-> Apps configured!'

# Configure macos
echo '3. Configuring macOS...'
# ./macos/install.sh
# echo '-> macOS configured!'
echo '-> macOS skipped!'

# Restart
echo '4. Done! Restart your computer to take effect.'
