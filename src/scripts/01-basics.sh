#!/usr/bin/env bash

# Source the OS detection script
source "$(dirname "$0")/00-detect-os.sh"

echo "Using package manager: $PKG_MGR"

# Ask user to choose between Snap and Flatpak
echo "Which package manager would you like to use for GUI applications?"
echo "1) Flatpak (recommended)"
echo "2) Snap"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "Installing Flatpak..."
        # Install Flatpak if not present
        if ! command -v flatpak >/dev/null; then
            echo "Flatpak not found. Installing..."
            $INSTALL_CMD flatpak
            
            # Add Flathub repository
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            echo "Flatpak installed and Flathub repository added successfully"
        else
            echo "Flatpak is already installed"
        fi
        ;;
    2)
        echo "Installing Snap..."
        # Install Snapd if not present
        if ! command -v snap >/dev/null; then
            echo "Snapd not found. Installing..."
            $INSTALL_CMD snapd
            echo "Snapd installed successfully"
        else
            echo "Snapd is already installed"
        fi
        ;;
    *)
        echo "Invalid choice. Defaulting to Flatpak..."
        # Install Flatpak if not present
        if ! command -v flatpak >/dev/null; then
            echo "Flatpak not found. Installing..."
            $INSTALL_CMD flatpak
            
            # Add Flathub repository
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            echo "Flatpak installed and Flathub repository added successfully"
        else
            echo "Flatpak is already installed"
        fi
        ;;
esac

# Install and configure Zsh
echo ""
echo "Setting up Zsh..."

# Install Zsh if not present
if ! command -v zsh >/dev/null; then
    echo "Zsh not found. Installing..."
    $INSTALL_CMD zsh
    echo "Zsh installed successfully"
else
    echo "Zsh is already installed"
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh My Zsh installed successfully"
else
    echo "Oh My Zsh is already installed"
fi

# Install zsh-autosuggestions plugin
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    echo "zsh-autosuggestions plugin installed successfully"
else
    echo "zsh-autosuggestions plugin is already installed"
fi

# Install autojump
if ! command -v autojump >/dev/null; then
    echo "Installing autojump..."
    $INSTALL_CMD autojump
    echo "autojump installed successfully"
else
    echo "autojump is already installed"
fi

# Apply Zsh configuration
SCRIPT_DIR="$(dirname "$(dirname "$0")")"
CONFIG_FILE="$SCRIPT_DIR/config/zshrc.conf"

if [ -f "$CONFIG_FILE" ]; then
    echo "Applying Zsh configuration..."
    
    # Replace package manager placeholders in the config
    sed "s/{{ PKG_MGR }}/$PKG_MGR/g" "$CONFIG_FILE" > "$HOME/.zshrc"
    
    echo "Zsh configuration applied successfully"
    echo "To use Zsh as your default shell, run: chsh -s \$(which zsh)"
else
    echo "Warning: Zsh configuration file not found at $CONFIG_FILE"
fi


