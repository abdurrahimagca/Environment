#!/usr/bin/env bash

# Source the OS detection script
source "$(dirname "$0")/00-detect-os.sh"

echo "Configuring system settings..."

# Configure GNOME settings (if running GNOME)
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || command -v gnome-shell >/dev/null; then
    echo "Configuring GNOME settings..."
    
    # Set dark theme
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    
    # Configure terminal
    gsettings set org.gnome.desktop.default-applications.terminal exec 'gnome-terminal'
    
    # Configure file manager
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
    gsettings set org.gnome.nautilus.list-view use-tree-view true
    
    # Configure desktop
    gsettings set org.gnome.desktop.background show-desktop-icons false
    gsettings set org.gnome.shell.extensions.desktop-icons show-home false
    gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
    
    # Configure power settings
    gsettings set org.gnome.desktop.session idle-delay 900  # 15 minutes
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0  # Never
    
    # Configure keyboard shortcuts
    gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t']"
    
    echo "GNOME settings configured"
else
    echo "Not running GNOME, skipping GNOME-specific settings"
fi

# Install and configure fonts
echo "Installing additional fonts..."
if [ -d "/usr/share/fonts" ]; then
    # Create user fonts directory
    mkdir -p "$HOME/.local/share/fonts"
    
    # Download and install JetBrains Mono (popular programming font)
    if [ ! -f "$HOME/.local/share/fonts/JetBrainsMono-Regular.ttf" ]; then
        echo "Installing JetBrains Mono font..."
        curl -L "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip" -o /tmp/jetbrains-mono.zip
        unzip -q /tmp/jetbrains-mono.zip -d /tmp/jetbrains-mono
        cp /tmp/jetbrains-mono/fonts/ttf/*.ttf "$HOME/.local/share/fonts/"
        rm -rf /tmp/jetbrains-mono*
        fc-cache -fv
        echo "JetBrains Mono font installed"
    fi
fi

# Configure Git with better defaults
if command -v git >/dev/null; then
    echo "Configuring Git defaults..."
    git config --global core.editor "nvim"
    git config --global merge.tool "vimdiff"
    git config --global diff.tool "vimdiff"
    git config --global push.default "simple"
    git config --global branch.autosetuprebase "always"
    echo "Git defaults configured"
fi

# Setup firewall (if available)
if command -v ufw >/dev/null; then
    echo "Configuring basic firewall..."
    sudo ufw --force enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    echo "Basic firewall configured"
fi

# Create useful directories
echo "Creating standard directories..."
mkdir -p "$HOME/Desktop" "$HOME/Documents" "$HOME/Downloads" "$HOME/Pictures"
mkdir -p "$HOME/Projects" "$HOME/Scripts" "$HOME/.config"

# Set up some security settings
echo "Applying basic security settings..."

# Disable core dumps for security
echo "* hard core 0" | sudo tee -a /etc/security/limits.conf >/dev/null

# Set proper permissions for home directory
chmod 750 "$HOME" 2>/dev/null || true

echo "System configuration completed!"