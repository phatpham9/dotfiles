#!/bin/bash

# Utility functions for dotfiles installation

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Global variables
DOTFILES_DIR=""
CONFIG_FILE=""
PROFILE=""
BACKUP_DIR=""
VERBOSE=false
DRY_RUN=false

# Initialize utilities
init_utils() {
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    CONFIG_FILE="${DOTFILES_DIR}/configs/config.yml"
    BACKUP_DIR="${HOME}/.dotfiles_backup"
}

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

print_verbose() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[VERBOSE]${NC} $1"
    fi
}

# Platform detection
is_macos() {
    [[ "$(uname)" == "Darwin" ]]
}

is_linux() {
    [[ "$(uname)" == "Linux" ]]
}

get_platform() {
    if is_macos; then
        echo "macos"
    elif is_linux; then
        echo "linux"
    else
        echo "unknown"
    fi
}

# Command existence check
command_exists() {
    command -v "$1" &> /dev/null
}

# File operations
backup_file() {
    local file="$1"
    if [[ -f "$file" || -L "$file" ]]; then
        local backup_file="${BACKUP_DIR}/$(basename "$file").backup.$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        cp "$file" "$backup_file" 2>/dev/null || true
        print_verbose "Backed up $file to $backup_file"
    fi
}

create_symlink() {
    local source="$1"
    local target="$2"
    local force="${3:-false}"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would create symlink: $source -> $target"
        return 0
    fi
    
    # Create target directory if it doesn't exist
    local target_dir
    target_dir="$(dirname "$target")"
    mkdir -p "$target_dir"
    
    # Backup existing file/symlink
    if [[ -e "$target" ]]; then
        if [[ "$force" == true ]]; then
            backup_file "$target"
            rm -f "$target"
        else
            print_warning "Target already exists: $target"
            return 1
        fi
    fi
    
    # Create symlink
    if ln -sf "$source" "$target"; then
        print_success "Created symlink: $source -> $target"
        return 0
    else
        print_error "Failed to create symlink: $source -> $target"
        return 1
    fi
}

# YAML parsing (simplified)
get_config_value() {
    local key="$1"
    local config_file="${2:-$CONFIG_FILE}"
    
    if [[ ! -f "$config_file" ]]; then
        print_error "Config file not found: $config_file"
        return 1
    fi
    
    # Simple YAML parsing for basic key-value pairs
    # This is a simplified version - for complex YAML, consider using yq
    grep "^${key}:" "$config_file" | sed "s/^${key}:[[:space:]]*//" | sed "s/['\"]//g"
}

# Profile management
load_profile() {
    local profile_name="$1"
    local profile_file="${DOTFILES_DIR}/configs/profiles/${profile_name}.yml"
    
    if [[ -f "$profile_file" ]]; then
        PROFILE="$profile_name"
        print_info "Loaded profile: $profile_name"
        return 0
    else
        print_error "Profile not found: $profile_name"
        return 1
    fi
}

# Error handling
handle_error() {
    local exit_code=$?
    local line_number="$1"
    print_error "An error occurred on line $line_number (exit code: $exit_code)"
    exit "$exit_code"
}

# Set up error handling
set_error_handling() {
    set -eE
    trap 'handle_error $LINENO' ERR
}

# Confirmation prompt
confirm() {
    local message="$1"
    local default="${2:-n}"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would prompt: $message"
        return 0
    fi
    
    local prompt
    if [[ "$default" == "y" ]]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi
    
    read -p "$message $prompt " -n 1 -r
    echo
    
    if [[ "$default" == "y" ]]; then
        [[ $REPLY =~ ^[Nn]$ ]] && return 1 || return 0
    else
        [[ $REPLY =~ ^[Yy]$ ]] && return 0 || return 1
    fi
}

# Progress indicator
show_progress() {
    local current="$1"
    local total="$2"
    local task="$3"
    local percentage=$((current * 100 / total))
    
    print_info "[$current/$total] ($percentage%) $task"
}

# Validate environment
validate_environment() {
    # Check if we're in the dotfiles directory
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_error "Config file not found. Are you running this from the dotfiles directory?"
        return 1
    fi
    
    # Check for required tools
    local required_tools=("curl" "git")
    for tool in "${required_tools[@]}"; do
        if ! command_exists "$tool"; then
            print_error "Required tool not found: $tool"
            return 1
        fi
    done
    
    return 0
}

# Initialize on source
init_utils
