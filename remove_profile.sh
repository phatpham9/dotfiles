#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_DIR="${HOME}/.ssh"
SSH_CONFIG_DIR="${DIR}/configs/ssh"
GIT_CONFIG_DIR="${DIR}/configs/git"

# source utils
source "${DIR}/utils/to_snake_case.sh"

# Prompt for profile name
echo "=== Profile Removal ==="
echo ""
read -p "Enter profile name to remove: " PROFILE_INPUT
echo ""

# Convert profile name to snake_case
PROFILE=$(to_snake_case "${PROFILE_INPUT}")
echo "Profile name (snake_case): ${PROFILE}"
echo ""

# Define file paths
SSH_KEY="${SSH_DIR}/id_ed25519_${PROFILE}"
SSH_KEY_PUB="${SSH_KEY}.pub"
SSH_CONFIG_SOURCE="${SSH_CONFIG_DIR}/config_${PROFILE}"
SSH_CONFIG_TARGET="${SSH_DIR}/config_${PROFILE}"
GIT_CONFIG_SOURCE="${GIT_CONFIG_DIR}/gitconfig_${PROFILE}"
GIT_CONFIG_TARGET="${HOME}/.gitconfig_${PROFILE}"
MAIN_GITCONFIG="${GIT_CONFIG_DIR}/gitconfig"

# Confirmation prompt
echo "WARNING: This will remove the following files and configurations:"
echo "  - SSH key: ${SSH_KEY}"
echo "  - SSH key (public): ${SSH_KEY_PUB}"
echo "  - SSH config: ${SSH_CONFIG_SOURCE}"
echo "  - SSH config symlink: ${SSH_CONFIG_TARGET}"
echo "  - Git config: ${GIT_CONFIG_SOURCE}"
echo "  - Git config symlink: ${GIT_CONFIG_TARGET}"
echo "  - includeIf section in: ${MAIN_GITCONFIG}"
echo ""
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [ "${CONFIRM}" != "yes" ]; then
  echo "Removal cancelled."
  exit 0
fi

echo ""
echo "Starting removal..."
echo ""

# Step 1: Remove includeIf from main gitconfig
echo "Step 1: Removing includeIf from main gitconfig..."
if [ -f "${MAIN_GITCONFIG}" ]; then
  # Remove lines containing the profile in gitdir pattern
  sed -i '' "/~\/code\/${PROFILE}\//d" "${MAIN_GITCONFIG}"
  # Remove lines containing the gitconfig path
  sed -i '' "/~\/.gitconfig_${PROFILE}/d" "${MAIN_GITCONFIG}"
  echo "-> Removed includeIf for ${PROFILE} from gitconfig."
else
  echo "-> Main gitconfig not found."
fi
echo ""

# Step 2: Remove Git config symlink
echo "Step 2: Removing Git config symlink..."
if [ -L "${GIT_CONFIG_TARGET}" ]; then
  rm "${GIT_CONFIG_TARGET}"
  echo "-> Removed ${GIT_CONFIG_TARGET}"
elif [ -f "${GIT_CONFIG_TARGET}" ]; then
  echo "-> ${GIT_CONFIG_TARGET} exists but is not a symlink. Skipping."
else
  echo "-> ${GIT_CONFIG_TARGET} not found."
fi
echo ""

# Step 3: Remove Git config file
echo "Step 3: Removing Git config file..."
if [ -f "${GIT_CONFIG_SOURCE}" ]; then
  rm "${GIT_CONFIG_SOURCE}"
  echo "-> Removed ${GIT_CONFIG_SOURCE}"
else
  echo "-> ${GIT_CONFIG_SOURCE} not found."
fi
echo ""

# Step 4: Remove SSH config symlink
echo "Step 4: Removing SSH config symlink..."
if [ -L "${SSH_CONFIG_TARGET}" ]; then
  rm "${SSH_CONFIG_TARGET}"
  echo "-> Removed ${SSH_CONFIG_TARGET}"
elif [ -f "${SSH_CONFIG_TARGET}" ]; then
  echo "-> ${SSH_CONFIG_TARGET} exists but is not a symlink. Skipping."
else
  echo "-> ${SSH_CONFIG_TARGET} not found."
fi
echo ""

# Step 5: Remove SSH config file
echo "Step 5: Removing SSH config file..."
if [ -f "${SSH_CONFIG_SOURCE}" ]; then
  rm "${SSH_CONFIG_SOURCE}"
  echo "-> Removed ${SSH_CONFIG_SOURCE}"
else
  echo "-> ${SSH_CONFIG_SOURCE} not found."
fi
echo ""

# Step 6: Remove SSH keys
echo "Step 6: Removing SSH keys..."
if [ -f "${SSH_KEY}" ]; then
  rm "${SSH_KEY}"
  echo "-> Removed ${SSH_KEY}"
else
  echo "-> ${SSH_KEY} not found."
fi

if [ -f "${SSH_KEY_PUB}" ]; then
  rm "${SSH_KEY_PUB}"
  echo "-> Removed ${SSH_KEY_PUB}"
else
  echo "-> ${SSH_KEY_PUB} not found."
fi
echo ""

echo "=== Profile Removal Complete ==="
echo ""
echo "Profile '${PROFILE}' has been removed successfully."
echo ""
