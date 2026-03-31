#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Shared skills location (cross-compatible standard)
AGENTS_DIR="${HOME}/.agents"

# Tool-specific locations
COPILOT_DIR="${HOME}/.copilot"
GEMINI_DIR="${HOME}/.gemini"

# source utils
source "${DIR}/../../utils/create_symlink.sh"

configure_ai_agents() {
  # Shared Skills (cross-compatible standard)
  mkdir -p "${AGENTS_DIR}"
  create_symlink "${DIR}/skills" "${AGENTS_DIR}/skills"

  # GitHub Copilot (VS Code extension + Copilot CLI)
  mkdir -p "${COPILOT_DIR}"
  create_symlink "${DIR}/agents" "${COPILOT_DIR}/agents"
  # MCP config for Copilot CLI. VS Code extension mcp-config is managed separately in the VS Code settings
  create_symlink "${DIR}/mcp-config.json" "${COPILOT_DIR}/mcp-config.json"

  # Antigravity (Gemini)
  mkdir -p "${GEMINI_DIR}/antigravity"
  create_symlink "${DIR}/rules.md" "${GEMINI_DIR}/GEMINI.md"
  create_symlink "${DIR}/skills" "${GEMINI_DIR}/antigravity/skills"
  create_symlink "${DIR}/mcp-config.json" "${GEMINI_DIR}/antigravity/mcp-config.json"
}

configure_ai_agents
