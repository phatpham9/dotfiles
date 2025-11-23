#!/bin/bash

# Function to generate SSH key
# Usage: generate_ssh_key <key_path> <email>
generate_ssh_key() {
  local key_path="$1"
  local email="$2"
  
  if [ ! -f "${key_path}" ]; then
    ssh-keygen -t ed25519 -C "${email}" -f "${key_path}" -P ""
    echo "-> SSH key ${key_path} created."
  else
    echo "-> SSH key ${key_path} already exists."
  fi
}
