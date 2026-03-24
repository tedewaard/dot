#!/usr/bin/env bash
#
# Dotfiles Installation Script
#
# Usage:
#   ./install.sh              # Run installation
#
# Features:
#   - Automatically backs up existing files with .bak suffix
#   - Creates necessary directories
#   - Installs TPM (Tmux Plugin Manager)
#   - Idempotent (safe to run multiple times)
#
# Symlink Mappings:
#   Home Directory:
#     .bashrc, .profile, .tmux.conf, .xinitrc, .xprofile
#
#   ~/.config/:
#     nvim/, helix/, awesome/ (from awesomewm/), tmux-sessionizer/
#

# ============================================================================
# CONFIGURATION
# ============================================================================
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Script metadata
readonly SCRIPT_VERSION="1.0.0"
readonly SCRIPT_NAME="$(basename "$0")"

# Determine dotfiles directory (location of this script)
readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes for pretty output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Files to symlink to home directory
readonly HOME_FILES=(
    ".bashrc"
    ".profile"
    ".tmux.conf"
    ".xinitrc"
    ".xprofile"
)

# Directories to symlink to ~/.config
# Format: "source_dir:target_name"
declare -A CONFIG_DIRS=(
    ["nvim"]="nvim"
    ["helix"]="helix"
    ["awesomewm"]="awesome"
    ["tmux-sessionizer"]="tmux-sessionizer"
)

# TPM repository URL
readonly TPM_REPO="https://github.com/tmux-plugins/tpm"
readonly TPM_DIR="$HOME/.tmux/plugins/tpm"

# Track operations for summary
declare -i SYMLINKS_CREATED=0
declare -i SYMLINKS_SKIPPED=0
declare -i BACKUPS_CREATED=0

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

print_header() {
    local message="$1"
    echo -e "\n${BOLD}${BLUE}==>${NC} ${BOLD}${message}${NC}"
}

print_success() {
    local message="$1"
    echo -e "${GREEN}  ✓${NC} ${message}"
}

print_error() {
    local message="$1"
    echo -e "${RED}  ✗${NC} ${message}" >&2
}

print_info() {
    local message="$1"
    echo -e "${BLUE}  →${NC} ${message}"
}

print_warning() {
    local message="$1"
    echo -e "${YELLOW}  !${NC} ${message}"
}

# ============================================================================
# CORE FUNCTIONS
# ============================================================================

# Backup existing file or directory with timestamp
backup_path() {
    local target="$1"

    # Check if target exists (file, directory, or symlink)
    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="${target}.bak.$(date +%Y%m%d_%H%M%S)"

        if mv "$target" "$backup"; then
            print_success "Backed up: $target → $(basename "$backup")"
            ((BACKUPS_CREATED++)) || true
            return 0
        else
            print_error "Failed to backup: $target"
            return 1
        fi
    fi

    return 0
}

# Create symlink with safety checks
create_symlink() {
    local source="$1"
    local target="$2"
    local target_name="${target/#$HOME/\~}"  # Replace home with ~ for display

    # Verify source exists
    if [ ! -e "$source" ]; then
        print_error "Source does not exist: $source"
        return 1
    fi

    # Check if already correctly symlinked (idempotent check)
    if [ -L "$target" ]; then
        local current_target
        current_target="$(readlink -f "$target")"
        local expected_target
        expected_target="$(readlink -f "$source")"

        if [ "$current_target" = "$expected_target" ]; then
            print_info "Already symlinked: $target_name"
            ((SYMLINKS_SKIPPED++)) || true
            return 0
        else
            print_warning "Symlink exists but points to wrong location: $target_name"
            backup_path "$target" || return 1
        fi
    elif [ -e "$target" ]; then
        # Target exists but is not a symlink - back it up
        backup_path "$target" || return 1
    fi

    # Create the symlink
    if ln -s "$source" "$target"; then
        print_success "Symlinked: $target_name → $source"
        ((SYMLINKS_CREATED++)) || true
        return 0
    else
        print_error "Failed to create symlink: $target_name"
        return 1
    fi
}

# Ensure directory exists
ensure_directory() {
    local dir="$1"

    if [ ! -d "$dir" ]; then
        if mkdir -p "$dir"; then
            print_success "Created directory: ${dir/#$HOME/\~}"
            return 0
        else
            print_error "Failed to create directory: $dir"
            return 1
        fi
    fi

    return 0
}

# Validate that dotfiles directory has expected structure
validate_environment() {
    print_header "Validating Environment"

    local all_valid=true

    # Check that we're in the dotfiles directory
    if [ ! -f "$DOTFILES_DIR/.bashrc" ]; then
        print_error "Cannot find .bashrc in $DOTFILES_DIR"
        print_error "Please run this script from the dotfiles directory"
        all_valid=false
    fi

    # Check for expected files
    for file in "${HOME_FILES[@]}"; do
        if [ ! -f "$DOTFILES_DIR/$file" ]; then
            print_warning "Expected file not found: $file"
        fi
    done

    # Check for expected directories
    for source_dir in "${!CONFIG_DIRS[@]}"; do
        if [ ! -d "$DOTFILES_DIR/$source_dir" ]; then
            print_warning "Expected directory not found: $source_dir"
        fi
    done

    if [ "$all_valid" = false ]; then
        return 1
    fi

    print_success "Environment validation passed"
    return 0
}

# Symlink files to home directory
symlink_home_files() {
    print_header "Symlinking Home Directory Files"

    for file in "${HOME_FILES[@]}"; do
        local source="$DOTFILES_DIR/$file"
        local target="$HOME/$file"

        if [ -f "$source" ]; then
            create_symlink "$source" "$target"
        else
            print_warning "Skipping missing file: $file"
        fi
    done
}

# Symlink directories to ~/.config
symlink_config_directories() {
    print_header "Symlinking Config Directories"

    # Ensure ~/.config exists
    ensure_directory "$HOME/.config"

    for source_dir in "${!CONFIG_DIRS[@]}"; do
        local target_name="${CONFIG_DIRS[$source_dir]}"
        local source="$DOTFILES_DIR/$source_dir"
        local target="$HOME/.config/$target_name"

        if [ -d "$source" ]; then
            create_symlink "$source" "$target"
        else
            print_warning "Skipping missing directory: $source_dir"
        fi
    done
}

# Install Tmux Plugin Manager
install_tpm() {
    print_header "Installing Tmux Plugin Manager (TPM)"

    if [ -d "$TPM_DIR/.git" ]; then
        print_info "TPM already installed at $TPM_DIR"
        return 0
    fi

    if [ -e "$TPM_DIR" ]; then
        print_warning "Directory exists but is not a git repository: $TPM_DIR"
        backup_path "$TPM_DIR" || return 1
    fi

    # Create parent directory if needed
    ensure_directory "$(dirname "$TPM_DIR")"

    print_info "Cloning TPM from $TPM_REPO..."
    if git clone "$TPM_REPO" "$TPM_DIR" >/dev/null 2>&1; then
        print_success "TPM installed successfully"
        return 0
    else
        print_error "Failed to clone TPM repository"
        print_info "You can manually install TPM with: git clone $TPM_REPO $TPM_DIR"
        return 1
    fi
}

# Verify all expected symlinks are in place
verify_installation() {
    print_header "Verifying Installation"

    local all_valid=true
    local checked=0
    local valid=0

    # Check home files
    for file in "${HOME_FILES[@]}"; do
        local source="$DOTFILES_DIR/$file"
        local target="$HOME/$file"

        if [ ! -f "$source" ]; then
            continue  # Skip files that don't exist in source
        fi

        ((checked++)) || true

        if [ -L "$target" ]; then
            local current_target
            current_target="$(readlink -f "$target")"
            local expected_target
            expected_target="$(readlink -f "$source")"

            if [ "$current_target" = "$expected_target" ]; then
                ((valid++)) || true
            else
                print_error "Invalid symlink: ${target/#$HOME/\~}"
                all_valid=false
            fi
        else
            print_error "Not a symlink: ${target/#$HOME/\~}"
            all_valid=false
        fi
    done

    # Check config directories
    for source_dir in "${!CONFIG_DIRS[@]}"; do
        local target_name="${CONFIG_DIRS[$source_dir]}"
        local source="$DOTFILES_DIR/$source_dir"
        local target="$HOME/.config/$target_name"

        if [ ! -d "$source" ]; then
            continue  # Skip directories that don't exist in source
        fi

        ((checked++)) || true

        if [ -L "$target" ]; then
            local current_target
            current_target="$(readlink -f "$target")"
            local expected_target
            expected_target="$(readlink -f "$source")"

            if [ "$current_target" = "$expected_target" ]; then
                ((valid++)) || true
            else
                print_error "Invalid symlink: ${target/#$HOME/\~}"
                all_valid=false
            fi
        else
            print_error "Not a symlink: ${target/#$HOME/\~}"
            all_valid=false
        fi
    done

    if [ "$all_valid" = true ]; then
        print_success "All $valid/$checked symlinks verified successfully"
        return 0
    else
        print_warning "Some symlinks are invalid ($valid/$checked verified)"
        return 1
    fi
}

# Print post-installation instructions
print_post_install_instructions() {
    print_header "Installation Complete!"

    echo -e "\n${BOLD}Summary:${NC}"
    echo -e "  Symlinks created: ${GREEN}$SYMLINKS_CREATED${NC}"
    echo -e "  Symlinks skipped (already correct): ${BLUE}$SYMLINKS_SKIPPED${NC}"
    echo -e "  Backups created: ${YELLOW}$BACKUPS_CREATED${NC}"

    echo -e "\n${BOLD}Next Steps:${NC}"
    echo -e "  ${BLUE}1.${NC} Reload your shell configuration:"
    echo -e "     ${YELLOW}source ~/.bashrc${NC}  or restart your terminal"
    echo -e ""
    echo -e "  ${BLUE}2.${NC} Install tmux plugins (if using tmux):"
    echo -e "     Open tmux and press ${YELLOW}Ctrl-A${NC} + ${YELLOW}I${NC} (capital i)"
    echo -e ""
    echo -e "  ${BLUE}3.${NC} Your dotfiles are now symlinked from:"
    echo -e "     ${YELLOW}$DOTFILES_DIR${NC}"
    echo -e ""

    if [ "$BACKUPS_CREATED" -gt 0 ]; then
        echo -e "${BOLD}Note:${NC} Your old configuration files have been backed up with ${YELLOW}.bak${NC} suffix"
        echo -e "      You can safely delete them once you've verified everything works."
        echo -e ""
    fi
}

# ============================================================================
# MAIN FUNCTION
# ============================================================================

main() {
    echo -e "${BOLD}${BLUE}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║   Dotfiles Installation Script v$SCRIPT_VERSION   ║"
    echo "╔═══════════════════════════════════════════╝"
    echo -e "${NC}"

    print_info "Dotfiles directory: $DOTFILES_DIR"

    # Step 1: Validate environment
    if ! validate_environment; then
        print_error "Environment validation failed. Exiting."
        exit 1
    fi

    # Step 2: Symlink home files
    symlink_home_files

    # Step 3: Symlink config directories
    symlink_config_directories

    # Step 4: Install TPM
    install_tpm

    # Step 5: Verify installation
    verify_installation

    # Step 6: Print post-install instructions
    print_post_install_instructions

    echo -e "${GREEN}${BOLD}✓ Installation successful!${NC}\n"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
