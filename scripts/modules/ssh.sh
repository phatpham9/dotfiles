#!/bin/bash

# SSH configuration module

# Source utilities
source "$(dirname "${BASH_SOURCE[0]}")/../lib/utils.sh"

# Generate SSH key
generate_ssh_key() {
    local key_name="$1"
    local email="$2"
    local key_file="$3"
    local key_path="${HOME}/.ssh/${key_file}"
    
    print_info "Generating SSH key: $key_name"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would generate SSH key: $key_path for $email"
        return 0
    fi
    
    # Create .ssh directory if it doesn't exist
    mkdir -p "${HOME}/.ssh"
    chmod 700 "${HOME}/.ssh"
    
    # Check if key already exists
    if [[ -f "$key_path" ]]; then
        print_warning "SSH key already exists: $key_path"
        return 0
    fi
    
    # Generate SSH key
    ssh-keygen -t ed25519 -C "$email" -f "$key_path" -P ""
    
    if [[ $? -eq 0 ]]; then
        print_success "Generated SSH key: $key_path"
        print_info "Public key: ${key_path}.pub"
        
        # Set proper permissions
        chmod 600 "$key_path"
        chmod 644 "${key_path}.pub"
        
        return 0
    else
        print_error "Failed to generate SSH key: $key_path"
        return 1
    fi
}

# Configure SSH from profile
configure_ssh_from_profile() {
    local profile_name="$1"
    local profile_file="${DOTFILES_DIR}/configs/profiles/${profile_name}.yml"
    
    if [[ ! -f "$profile_file" ]]; then
        print_error "Profile file not found: $profile_file"
        return 1
    fi
    
    print_info "Configuring SSH keys from profile: $profile_name"
    
    # Extract SSH key configuration from profile (simplified YAML parsing)
    # In production, use a proper YAML parser like yq
    local in_ssh_keys=false
    local current_key_name=""
    local current_key_email=""
    local current_key_file=""
    
    while IFS= read -r line; do
        # Remove leading whitespace
        line="${line#"${line%%[![:space:]]*}"}"
        
        if [[ "$line" == "keys:" ]]; then
            in_ssh_keys=true
            continue
        fi
        
        if [[ "$in_ssh_keys" == true ]]; then
            # Check if we've moved to a new section
            if [[ "$line" =~ ^[a-zA-Z] && ! "$line" =~ ^-[[:space:]] ]]; then
                in_ssh_keys=false
                continue
            fi
            
            if [[ "$line" =~ ^-[[:space:]]name:[[:space:]]* ]]; then
                # New key entry
                current_key_name=$(echo "$line" | sed "s/^-[[:space:]]*name:[[:space:]]*//" | sed "s/['\"]//g")
            elif [[ "$line" =~ ^email:[[:space:]]* ]]; then
                current_key_email=$(echo "$line" | sed "s/^email:[[:space:]]*//" | sed "s/['\"]//g")
            elif [[ "$line" =~ ^file:[[:space:]]* ]]; then
                current_key_file=$(echo "$line" | sed "s/^file:[[:space:]]*//" | sed "s/['\"]//g")
                
                # Generate key if we have all required info
                if [[ -n "$current_key_name" && -n "$current_key_email" && -n "$current_key_file" ]]; then
                    generate_ssh_key "$current_key_name" "$current_key_email" "$current_key_file"
                fi
                
                # Reset variables
                current_key_name=""
                current_key_email=""
                current_key_file=""
            fi
        fi
    done < "$profile_file"
}

# Configure SSH config files
configure_ssh_configs() {
    print_info "Configuring SSH config files..."
    
    local ssh_config_dir="${HOME}/.ssh"
    
    # Create main SSH config symlink
    create_symlink "${DOTFILES_DIR}/configs/ssh/config" "${ssh_config_dir}/config" true
    
    # Create additional SSH config files if they exist
    if [[ -f "${DOTFILES_DIR}/configs/ssh/config_secondary" ]]; then
        create_symlink "${DOTFILES_DIR}/configs/ssh/config_secondary" "${ssh_config_dir}/config_secondary" true
    fi
    
    if [[ -f "${DOTFILES_DIR}/configs/ssh/config_saypien" ]]; then
        create_symlink "${DOTFILES_DIR}/configs/ssh/config_saypien" "${ssh_config_dir}/config_saypien" true
    fi
    
    print_success "SSH config files configured"
}

# Show SSH key information
show_ssh_keys() {
    print_info "SSH Key Summary:"
    echo
    
    local ssh_dir="${HOME}/.ssh"
    local found_keys=false
    
    for key_file in "$ssh_dir"/id_*; do
        if [[ -f "$key_file" && ! "$key_file" == *.pub ]]; then
            found_keys=true
            local key_name=$(basename "$key_file")
            local pub_file="${key_file}.pub"
            
            if [[ -f "$pub_file" ]]; then
                print_info "🔑 $key_name"
                print_info "   Private: $key_file"
                print_info "   Public:  $pub_file"
                
                # Show key fingerprint
                local fingerprint
                fingerprint=$(ssh-keygen -lf "$pub_file" 2>/dev/null | awk '{print $2}')
                if [[ -n "$fingerprint" ]]; then
                    print_info "   Fingerprint: $fingerprint"
                fi
                echo
            fi
        fi
    done
    
    if [[ "$found_keys" == false ]]; then
        print_warning "No SSH keys found"
    else
        echo
        print_warning "⚠️  Don't forget to add these public keys to:"
        print_info "   • GitHub (https://github.com/settings/keys)"
        print_info "   • GitLab (https://gitlab.com/-/profile/keys)"
        print_info "   • Your servers' ~/.ssh/authorized_keys"
    fi
}

# Validate SSH setup
validate_ssh_setup() {
    print_info "Validating SSH setup..."
    
    # Check SSH agent
    if ! ssh-add -l &>/dev/null; then
        print_warning "SSH agent is not running or has no keys loaded"
        print_info "You may want to run: ssh-add ~/.ssh/id_*"
    else
        print_success "SSH agent is running with loaded keys"
    fi
    
    # Check SSH config
    if [[ -f "${HOME}/.ssh/config" ]]; then
        print_success "SSH config file exists"
    else
        print_warning "SSH config file not found"
    fi
    
    return 0
}

# Main SSH setup function
setup_ssh() {
    show_progress 1 4 "Configuring SSH"
    
    if [[ "$PROFILE" ]]; then
        configure_ssh_from_profile "$PROFILE"
    else
        # Generate default SSH key if none exists
        if [[ ! -f "${HOME}/.ssh/id_ed25519" ]]; then
            local default_email
            default_email=$(get_config_value "email" "$CONFIG_FILE")
            generate_ssh_key "primary" "$default_email" "id_ed25519"
        fi
    fi
    
    show_progress 2 4 "Setting up SSH config files"
    configure_ssh_configs
    
    show_progress 3 4 "Validating SSH setup"
    validate_ssh_setup
    
    show_progress 4 4 "SSH setup completed"
    show_ssh_keys
    
    print_success "SSH configuration completed"
}

# Allow running this script directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_ssh "$@"
fi
