#!/bin/bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_DIR="${HOME}/.docker"

# source utils
source "${DIR}/../../utils/create_symlink.sh"

configure_docker() {
  mkdir -p "${DOCKER_DIR}"
  create_symlink "${DIR}/config.json" "${DOCKER_DIR}/config.json"
}

configure_docker
