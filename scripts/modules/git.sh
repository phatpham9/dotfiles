#!/bin/bash

# Git configuration module

# Source utilities
source "$(dirname "${BASH_SOURCE[0]}")/../lib/utils.sh"

# Configure main git settings
configure_git_main() {
    local user_name="$1"
    local user_email="$2"
    local signing_key="$3"
    
    print_info "Configuring main Git settings..."
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would configure Git with:"
        print_info "  Name: $user_name"
        print_info "  Email: $user_email"
        print_info "  Signing key: $signing_key"
        return 0
    fi
    
    # Create main gitconfig from template
    local gitconfig_template="${DOTFILES_DIR}/configs/templates/gitconfig.template"
    local gitconfig_target="${HOME}/.gitconfig"
    
    if [[ -f "$gitconfig_template" ]]; then
        # Use template if available
        sed -e "s/{{USER_NAME}}/$user_name/g" \
            -e "s/{{USER_EMAIL}}/$user_email/g" \
            -e "s|{{SIGNING_KEY}}|$signing_key|g" \
            "$gitconfig_template" > "$gitconfig_target"
    else
        # Create from existing config
        create_symlink "${DOTFILES_DIR}/configs/git/gitconfig" "$gitconfig_target" true
    fi
    
    # Create other git config symlinks
    create_symlink "${DOTFILES_DIR}/configs/git/gitignore_global" "${HOME}/.gitignore_global" true
    
    print_success "Main Git configuration completed"
}

# Configure git profiles
configure_git_profiles() {
    print_info "Configuring Git profiles..."
    
    if [[ "$PROFILE" ]]; then
        local profile_file="${DOTFILES_DIR}/configs/profiles/${PROFILE}.yml"
        
        if [[ -f "$profile_file" ]]; then
            # Read profiles from YAML (simplified parsing)
            # In a real implementation, use proper YAML parsing tool like yq
            
            # Create secondary profile symlink
            if grep -q "secondary" "$profile_file"; then
                create_symlink "${DOTFILES_DIR}/configs/git/gitconfig_secondary" "${HOME}/.gitconfig_secondary" true
            fi
            
            # Create saypien profile symlink
            if grep -q "saypien" "$profile_file"; then
                create_symlink "${DOTFILES_DIR}/configs/git/gitconfig_saypien" "${HOME}/.gitconfig_saypien" true
            fi
        fi
    fi
    
    print_success "Git profiles configured"
}

# Generate Git configuration from profile
generate_git_config() {
    local profile_name="$1"
    local profile_file="${DOTFILES_DIR}/configs/profiles/${profile_name}.yml"
    
    if [[ ! -f "$profile_file" ]]; then
        print_error "Profile file not found: $profile_file"
        return 1
    fi
    
    # Extract user information from profile
    local user_name
    local user_email
    local signing_key
    
    user_name=$(grep "name:" "$profile_file" | head -1 | sed "s/.*name:[[:space:]]*//" | sed "s/['\"]//g")
    user_email=$(grep "email:" "$profile_file" | head -1 | sed "s/.*email:[[:space:]]*//" | sed "s/['\"]//g")
    signing_key=$(get_config_value "signing_key" "$CONFIG_FILE")
    
    if [[ -z "$user_name" || -z "$user_email" ]]; then
        print_error "Could not extract user information from profile"
        return 1
    fi
    
    configure_git_main "$user_name" "$user_email" "$signing_key"
    configure_git_profiles
}

# Validate git configuration
validate_git_config() {
    print_info "Validating Git configuration..."
    
    # Check if git is configured
    if ! git config --get user.name &>/dev/null; then
        print_error "Git user.name is not configured"
        return 1
    fi
    
    if ! git config --get user.email &>/dev/null; then
        print_error "Git user.email is not configured"
        return 1
    fi
    
    local user_name
    local user_email
    user_name=$(git config --get user.name)
    user_email=$(git config --get user.email)
    
    print_success "Git is configured for: $user_name <$user_email>"
    
    # Check signing configuration
    if git config --get commit.gpgsign &>/dev/null; then
        local signing_key
        signing_key=$(git config --get user.signingkey)
        print_success "Git signing is enabled with key: $signing_key"
    fi
    
    return 0
}

# Main git setup function
setup_git() {
    show_progress 1 3 "Configuring Git"
    
    if [[ "$PROFILE" ]]; then
        generate_git_config "$PROFILE"
    else
        # Use default configuration
        local user_name
        local user_email
        local signing_key
        
        user_name=$(get_config_value "name" "$CONFIG_FILE")
        user_email=$(get_config_value "email" "$CONFIG_FILE")
        signing_key=$(get_config_value "signing_key" "$CONFIG_FILE")
        
        configure_git_main "$user_name" "$user_email" "$signing_key"
    fi
    
    show_progress 2 3 "Validating Git configuration"
    validate_git_config
    
    show_progress 3 3 "Git setup completed"
    print_success "Git configuration completed"
}

# Allow running this script directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_git "$@"
fi
