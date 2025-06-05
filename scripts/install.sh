#!/bin/bash

# Main installation script for dotfiles
# This is the new modular version that replaces the original install.sh

set -euo pipefail

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/lib/utils.sh"

# Default options
PROFILE=""
MODULES=""
VERBOSE=false
DRY_RUN=false
FORCE=false
SKIP_DEPENDENCIES=false

# Usage information
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install and configure dotfiles with modular approach.

OPTIONS:
    -p, --profile PROFILE       Use specific profile (e.g., personal, work)
    -m, --modules MODULES       Comma-separated list of modules to install
                               Available: homebrew,git,ssh,zsh,gh,poetry
                               Default: all modules
    -v, --verbose              Enable verbose output
    -n, --dry-run              Show what would be done without executing
    -f, --force                Force overwrite existing configurations
    -s, --skip-dependencies    Skip system dependency installation
    -h, --help                 Show this help message

EXAMPLES:
    $0                         # Install everything with default config
    $0 -p personal             # Install with personal profile
    $0 -m homebrew,git         # Install only homebrew and git modules
    $0 -n -v                   # Dry run with verbose output
    $0 -p work -f              # Force install with work profile

PROFILES:
    Profiles are YAML files in configs/profiles/ that override default settings.
    Create your own profile by copying configs/profiles/personal.yml

MODULES:
    homebrew    - Install Homebrew and applications
    git         - Configure Git with signing and profiles
    ssh         - Generate SSH keys and configure SSH
    zsh         - Configure Zsh with oh-my-zsh
    gh          - Configure GitHub CLI
    poetry      - Configure Poetry for Python development

EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--profile)
                PROFILE="$2"
                shift 2
                ;;
            -m|--modules)
                MODULES="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            -s|--skip-dependencies)
                SKIP_DEPENDENCIES=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

# Install system dependencies
install_system_dependencies() {
    if [[ "$SKIP_DEPENDENCIES" == true ]]; then
        print_info "Skipping system dependencies installation"
        return 0
    fi
    
    print_info "Installing system dependencies..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would install system dependencies"
        return 0
    fi
    
    if is_macos; then
        # Install Xcode command line tools
        if ! xcode-select -p &>/dev/null; then
            print_info "Installing Xcode command line tools..."
            xcode-select --install
        fi
    else
        # Install build essentials for Linux
        if command_exists apt-get; then
            sudo apt-get update
            sudo apt-get install -y build-essential procps file curl git zsh
        elif command_exists yum; then
            sudo yum groupinstall -y "Development Tools"
            sudo yum install -y procps file curl git zsh
        elif command_exists pacman; then
            sudo pacman -S --needed base-devel procps file curl git zsh
        fi
    fi
    
    print_success "System dependencies installed"
}

# Load and validate profile
setup_profile() {
    if [[ -n "$PROFILE" ]]; then
        if ! load_profile "$PROFILE"; then
            print_error "Failed to load profile: $PROFILE"
            exit 1
        fi
    else
        print_info "Using default configuration"
    fi
}

# Get list of modules to install
get_modules_list() {
    if [[ -n "$MODULES" ]]; then
        echo "$MODULES" | tr ',' ' '
    else
        # Default modules
        echo "homebrew git ssh zsh gh poetry"
    fi
}

# Run a specific module
run_module() {
    local module="$1"
    local module_script="$SCRIPT_DIR/modules/$module.sh"
    
    if [[ ! -f "$module_script" ]]; then
        print_error "Module script not found: $module_script"
        return 1
    fi
    
    print_info "Running module: $module"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would run module: $module"
        return 0
    fi
    
    # Set environment variables for module
    export DOTFILES_DIR
    export PROFILE
    export VERBOSE
    export DRY_RUN
    export FORCE
    
    if bash "$module_script"; then
        print_success "Module completed: $module"
    else
        print_error "Module failed: $module"
        return 1
    fi
}

# Main installation function
main() {
    # Show banner
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                              Dotfiles Installer                             ║"
    echo "║                         Modular Configuration System                        ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo
    
    # Parse arguments
    parse_args "$@"
    
    # Set global options
    if [[ "$VERBOSE" == true ]]; then
        export VERBOSE=true
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        export DRY_RUN=true
        print_warning "DRY RUN MODE - No changes will be made"
        echo
    fi
    
    # Validate environment
    validate_environment
    
    # Setup profile
    setup_profile
    
    # Get modules list
    local modules_list
    modules_list="$(get_modules_list)"
    local modules_array=($modules_list)
    local total_steps=$((${#modules_array[@]} + 2))
    local current_step=1
    
    print_info "Installing modules: $modules_list"
    echo
    
    # Install system dependencies
    show_progress $current_step $total_steps "Installing system dependencies"
    install_system_dependencies
    ((current_step++))
    
    # Ask for sudo password upfront
    if [[ "$DRY_RUN" != true ]] && [[ "$SKIP_DEPENDENCIES" != true ]]; then
        print_info "Requesting administrator privileges..."
        sudo -v
        
        # Keep sudo alive
        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    fi
    
    # Run each module
    for module in $modules_list; do
        show_progress $current_step $total_steps "Setting up $module"
        
        if ! run_module "$module"; then
            print_error "Installation failed at module: $module"
            exit 1
        fi
        
        ((current_step++))
        echo
    done
    
    # Final steps
    show_progress $current_step $total_steps "Finalizing installation"
    
    # Summary
    echo
    print_success "✅ Dotfiles installation completed successfully!"
    echo
    print_info "Summary:"
    print_info "  Profile: ${PROFILE:-default}"
    print_info "  Modules: $modules_list"
    print_info "  Platform: $(get_platform)"
    
    if [[ "$DRY_RUN" != true ]]; then
        echo
        print_warning "⚠️  Please restart your terminal or run 'source ~/.zshrc' to apply changes"
        
        if [[ -d "$BACKUP_DIR" ]]; then
            print_info "📦 Backups saved to: $BACKUP_DIR"
        fi
    fi
    
    echo
    print_info "🎉 Enjoy your new development environment!"
}

# Run main function
main "$@"
