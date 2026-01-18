#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GEMINI_DIR="${HOME}/.gemini"

# source utils
source "${DIR}/../../utils/create_symlink.sh"

configure_antigravity() {
  # Ensure directories exist
  mkdir -p "${GEMINI_DIR}/antigravity"

  # Link GEMINI.md
  create_symlink "${DIR}/GEMINI.md" "${GEMINI_DIR}/GEMINI.md"

  # Link skills directory
  create_symlink "${DIR}/skills" "${GEMINI_DIR}/antigravity/skills"
}

configure_antigravity
