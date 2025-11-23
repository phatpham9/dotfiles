#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_DIR="${HOME}/.ssh"
SSH_CONFIG_DIR="${DIR}/configs/ssh"
GIT_CONFIG_DIR="${DIR}/configs/git"

# source utils
source "${DIR}/utils/create_symlink.sh"
source "${DIR}/utils/to_snake_case.sh"
source "${DIR}/utils/generate_ssh_key.sh"

# Prompt for user inputs
echo "=== Profile Setup ==="
echo ""
read -p "Enter profile name: " PROFILE_INPUT
read -p "Enter Git user.name: " GIT_NAME
read -p "Enter Git user.email: " GIT_EMAIL
echo ""

# Convert profile name to snake_case
PROFILE=$(to_snake_case "${PROFILE_INPUT}")
echo "Profile name (snake_case): ${PROFILE}"
echo ""

# Define file paths
SSH_KEY="${SSH_DIR}/id_ed25519_${PROFILE}"
SSH_CONFIG_SOURCE="${SSH_CONFIG_DIR}/config_${PROFILE}"
SSH_CONFIG_TARGET="${SSH_DIR}/config_${PROFILE}"
GIT_CONFIG_SOURCE="${GIT_CONFIG_DIR}/gitconfig_${PROFILE}"
GIT_CONFIG_TARGET="${HOME}/.gitconfig_${PROFILE}"
MAIN_GITCONFIG="${GIT_CONFIG_DIR}/gitconfig"

# Step 1: Generate SSH key
echo "Step 1: Generating SSH key..."
mkdir -p "${SSH_DIR}"
generate_ssh_key "${SSH_KEY}" "${GIT_EMAIL}"
echo ""

# Step 2: Create SSH config file
echo "Step 2: Creating SSH config file..."
cp "${SSH_CONFIG_DIR}/config_[profile]" "${SSH_CONFIG_SOURCE}"
sed -i '' "s/\[profile\]/${PROFILE}/g" "${SSH_CONFIG_SOURCE}"
echo "-> Created ${SSH_CONFIG_SOURCE}"
echo ""

# Step 3: Create symlink for SSH config
echo "Step 3: Creating symlink for SSH config..."
create_symlink "${SSH_CONFIG_SOURCE}" "${SSH_CONFIG_TARGET}"
echo ""

# Step 4: Create Git config file
echo "Step 4: Creating Git config file..."
cp "${GIT_CONFIG_DIR}/gitconfig_[profile]" "${GIT_CONFIG_SOURCE}"
sed -i '' "s/\[profile\]/${PROFILE}/g" "${GIT_CONFIG_SOURCE}"
sed -i '' "s/\[your-name\]/${GIT_NAME}/g" "${GIT_CONFIG_SOURCE}"
sed -i '' "s/\[your-email\]/${GIT_EMAIL}/g" "${GIT_CONFIG_SOURCE}"
echo "-> Created ${GIT_CONFIG_SOURCE}"
echo ""

# Step 5: Create symlink for Git config
echo "Step 5: Creating symlink for Git config..."
create_symlink "${GIT_CONFIG_SOURCE}" "${GIT_CONFIG_TARGET}"
echo ""

# Step 6: Add includeIf to main gitconfig
echo "Step 6: Adding includeIf to main gitconfig..."
# Extract the template from commented lines and replace [profile] placeholder
INCLUDE_IF_BLOCK=$(grep -A 1 '~\/code\/\[profile\]\/' "${MAIN_GITCONFIG}" | sed 's/^# //' | sed "s/\[profile\]/${PROFILE}/g")
echo "" >> "${MAIN_GITCONFIG}"
echo "${INCLUDE_IF_BLOCK}" >> "${MAIN_GITCONFIG}"
echo "-> Added includeIf for ${PROFILE} to gitconfig."
echo ""

echo "=== Profile Setup Complete ==="
echo ""
echo "Summary:"
echo "  Profile: ${PROFILE}"
echo "  Git Name: ${GIT_NAME}"
echo "  Git Email: ${GIT_EMAIL}"
echo "  SSH Key: ${SSH_KEY}"
echo "  SSH Config: ${SSH_CONFIG_TARGET}"
echo "  Git Config: ${GIT_CONFIG_TARGET}"
echo ""
echo "Next steps:"
echo "  1. Add SSH public key to your Git hosting service:"
echo "     cat ${SSH_KEY}.pub"
echo "  2. Create directory ~/code/${PROFILE}/ for your projects"
echo ""
