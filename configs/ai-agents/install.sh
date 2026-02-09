#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Shared skills location (cross-compatible standard)
AGENTS_DIR="${HOME}/.agents"

# Tool-specific locations
GEMINI_DIR="${HOME}/.gemini"

# source utils
source "${DIR}/../../utils/create_symlink.sh"

configure_ai_agents() {
  # Shared Skills (cross-compatible standard)
  mkdir -p "${AGENTS_DIR}"
  create_symlink "${DIR}/skills" "${AGENTS_DIR}/skills"

  # Antigravity (Gemini)
  mkdir -p "${GEMINI_DIR}/antigravity"
  create_symlink "${DIR}/rules.md" "${GEMINI_DIR}/GEMINI.md"
  create_symlink "${DIR}/skills" "${GEMINI_DIR}/antigravity/skills"
}

configure_ai_agents
