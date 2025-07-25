#!/usr/bin/env bash

# Source the OS detection script
source "$(dirname "$0")/00-detect-os.sh"

# Source the packages configuration
SCRIPT_DIR="$(dirname "$(dirname "$0")")"
source "$SCRIPT_DIR/config/packages.cfg"

echo "Installing packages using $PKG_MGR..."

# Function to install packages
install_packages() {
    local package_array=("$@")
    for package in "${package_array[@]}"; do
        if [ -n "$package" ]; then
            echo "Installing: $package"
            $INSTALL_CMD "$package"
        fi
    done
}

# Install general packages
echo "Installing general packages..."
install_packages "${PACKAGES[@]}"

# Install development tools
echo "Installing development tools..."
install_packages "${DEV_TOOLS[@]}"

# Install media applications
echo "Installing media applications..."
install_packages "${MEDIA[@]}"

# Install Flatpak packages if Flatpak is available
if command -v flatpak >/dev/null; then
    echo "Installing Flatpak applications..."
    for package in "${FLATPAK_PACKAGES[@]}"; do
        if [ -n "$package" ]; then
            echo "Installing Flatpak: $package"
            flatpak install -y flathub "$package"
        fi
    done
else
    echo "Flatpak not available, skipping Flatpak packages"
fi

# Install Snap packages if Snap is available
if command -v snap >/dev/null; then
    echo "Installing Snap applications..."
    for package in "${SNAP_PACKAGES[@]}"; do
        if [ -n "$package" ]; then
            echo "Installing Snap: $package"
            sudo snap install "$package"
        fi
    done
else
    echo "Snap not available, skipping Snap packages"
fi

echo "Package installation completed!"