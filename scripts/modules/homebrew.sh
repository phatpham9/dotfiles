#!/bin/bash

# Homebrew installation and configuration module

# Source utilities
source "$(dirname "${BASH_SOURCE[0]}")/../lib/utils.sh"

# Install Homebrew
install_homebrew() {
    print_info "Installing Homebrew..."
    
    if command_exists brew; then
        print_warning "Homebrew is already installed"
        return 0
    fi
    
    local platform
    platform="$(get_platform)"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would install Homebrew for platform: $platform"
        return 0
    fi
    
    # Install Homebrew
    print_info "Downloading and installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Set up Homebrew environment
    if is_macos; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # Install gcc for better compatibility
        /opt/homebrew/bin/brew install gcc
    else
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    
    print_success "Homebrew installed successfully"
}

# Update Homebrew
update_homebrew() {
    if ! command_exists brew; then
        print_error "Homebrew is not installed"
        return 1
    fi
    
    print_info "Updating Homebrew..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would update Homebrew"
        return 0
    fi
    
    brew update
    print_success "Homebrew updated successfully"
}

# Install packages from Brewfile
install_brewfile() {
    local brewfile="$1"
    local description="$2"
    
    if [[ ! -f "$brewfile" ]]; then
        print_error "Brewfile not found: $brewfile"
        return 1
    fi
    
    print_info "Installing $description from $brewfile..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would install packages from: $brewfile"
        return 0
    fi
    
    if brew bundle --file="$brewfile"; then
        print_success "$description installed successfully"
    else
        print_error "Failed to install $description"
        return 1
    fi
}

# Install CLI applications
install_cli_apps() {
    local brewfile="${DOTFILES_DIR}/apps/Brewfile_cli"
    install_brewfile "$brewfile" "CLI applications"
}

# Install GUI applications (macOS only)
install_gui_apps() {
    if ! is_macos; then
        print_info "Skipping GUI applications (not on macOS)"
        return 0
    fi
    
    local brewfile="${DOTFILES_DIR}/apps/Brewfile_gui"
    install_brewfile "$brewfile" "GUI applications"
}

# Cleanup Homebrew
cleanup_homebrew() {
    if ! command_exists brew; then
        print_warning "Homebrew is not installed, skipping cleanup"
        return 0
    fi
    
    print_info "Cleaning up Homebrew..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would cleanup Homebrew"
        return 0
    fi
    
    brew cleanup
    print_success "Homebrew cleanup completed"
}

# Main homebrew installation function
setup_homebrew() {
    local update_before_install=true
    local cleanup_after_install=true
    local install_gui=true
    
    # Read configuration (simplified - in a real implementation, use proper YAML parsing)
    if [[ -f "$CONFIG_FILE" ]]; then
        # Check if GUI apps should be installed based on platform config
        if ! is_macos && grep -q "install_gui_apps: false" "$CONFIG_FILE"; then
            install_gui=false
        fi
    fi
    
    show_progress 1 5 "Installing Homebrew"
    install_homebrew
    
    if [[ "$update_before_install" == true ]]; then
        show_progress 2 5 "Updating Homebrew"
        update_homebrew
    fi
    
    show_progress 3 5 "Installing CLI applications"
    install_cli_apps
    
    if [[ "$install_gui" == true ]]; then
        show_progress 4 5 "Installing GUI applications"
        install_gui_apps
    fi
    
    if [[ "$cleanup_after_install" == true ]]; then
        show_progress 5 5 "Cleaning up Homebrew"
        cleanup_homebrew
    fi
    
    print_success "Homebrew setup completed"
}

# Allow running this script directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_homebrew "$@"
fi
