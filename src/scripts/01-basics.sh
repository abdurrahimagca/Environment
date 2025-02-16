#!/bin/bash

# Source the OS detection script
source "$(dirname "$0")/00-detect-os.sh"

echo "Using package manager: $PKG_MGR"

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


