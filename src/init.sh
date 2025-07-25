#!/usr/bin/env bash

# Main initialization script for environment setup
# This script orchestrates the complete system setup

set -e  # Exit on any error

SCRIPT_DIR="$(dirname "$0")"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

echo "================================"
echo "  Environment Setup - Starting  "
echo "================================"
echo ""

# Function to run script with error handling
run_script() {
    local script="$1"
    local description="$2"
    
    echo "Running: $description"
    echo "----------------------------------------"
    
    if [ -f "$script" ] && [ -x "$script" ]; then
        if "$script"; then
            echo " $description - Completed successfully"
        else
            echo "L $description - Failed"
            echo "Error running: $script"
            exit 1
        fi
    else
        echo "�  Script not found or not executable: $script"
        return 1
    fi
    
    echo ""
}

# Make all scripts executable
echo "Making all scripts executable..."
chmod +x "$SCRIPTS_DIR"/*.sh
echo ""

# Step 1: OS Detection (automatically run by other scripts)
echo "Step 1: OS Detection will be handled automatically"
echo ""

# Step 2: Install basics (Flatpak/Snap choice, Zsh setup)
run_script "$SCRIPTS_DIR/01-basics.sh" "Basic system setup (Package managers, Zsh)"

# Step 3: Install all packages
run_script "$SCRIPTS_DIR/03-install-packages.sh" "Package installation"

# Step 4: Setup development environment
run_script "$SCRIPTS_DIR/04-dev-setup.sh" "Development environment setup"

# Step 5: Personalize (GNOME extensions)
run_script "$SCRIPTS_DIR/02-personalize.sh" "System personalization (GNOME extensions)"

# Step 6: System configuration
run_script "$SCRIPTS_DIR/05-system-config.sh" "System configuration (themes, settings, security)"

# Step 7: Apply dotfiles
run_script "$SCRIPTS_DIR/06-dotfiles.sh" "Dotfiles configuration (git, tmux, nvim, ssh)"

echo "================================"
echo "   Environment Setup Complete!   "
echo "================================"
echo ""
echo "<� Your system has been set up successfully!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or log out/in to apply all changes"
echo "2. Set Zsh as default shell: chsh -s \$(which zsh)"
echo "3. Install any additional GNOME extensions from https://extensions.gnome.org"
echo "4. Configure your Git credentials if not done during setup"
echo ""
echo "Enjoy your new development environment! =�"