#!/bin/bash

# ask for the administrator password upfront
sudo -v
# keep-alive: update existing `sudo` time stamp until `macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# install apps
echo "1. installing apps..."
./apps/install.sh
echo "-> apps installed!"

# configure apps
echo "2. configuring apps..."
./configs/install.sh
echo "-> apps configured!"

# configure macos preferences
echo "3. configuring macos preferences..."
./macos/install.sh
echo "-> macos preferences configured!"

# restart
echo "4. done! restart your machine to take effect."
