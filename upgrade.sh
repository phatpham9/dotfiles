#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# upgrade apps
echo "1. Upgrading apps..."
"${DIR}/apps/upgrade.sh"
echo "-> Apps upgraded!"

# upgrade configs
echo "2. Upgrading configs..."
"${DIR}/configs/upgrade.sh"
echo "-> Configs upgraded!"

# restart
echo "3. Done! Restart your shell and Claude Code for the changes to take effect."
