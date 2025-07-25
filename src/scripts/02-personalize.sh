#!/usr/bin/env bash

# Source the OS detection script
source "$(dirname "$0")/00-detect-os.sh"

# Source the packages configuration
SCRIPT_DIR="$(dirname "$(dirname "$0")")"
source "$SCRIPT_DIR/config/packages.cfg"

echo "Setting up GNOME extensions..."

# Install GNOME Shell Extensions support
if ! command -v gnome-extensions >/dev/null; then
    echo "Installing GNOME Shell Extensions support..."
    $INSTALL_CMD gnome-shell-extensions gnome-shell-extension-prefs
    echo "GNOME Shell Extensions support installed"
else
    echo "GNOME Shell Extensions support is already installed"
fi

# Install GNOME Extensions CLI tool if not present
if ! command -v gnome-extensions >/dev/null; then
    echo "Installing GNOME Extensions CLI tool..."
    $INSTALL_CMD gnome-shell-extension-manager
fi

# Function to install GNOME extension
install_gnome_extension() {
    local extension_id="$1"
    local extension_name="$2"
    
    echo "Installing GNOME extension: $extension_name"
    
    # Try to enable the extension if it's already installed
    if gnome-extensions list | grep -q "$extension_id"; then
        echo "Extension $extension_name is already installed"
        gnome-extensions enable "$extension_id"
        echo "Extension $extension_name enabled"
    else
        echo "Extension $extension_name needs to be installed manually from extensions.gnome.org"
        echo "Extension ID: $extension_id"
    fi
}

# Install each GNOME extension
echo "Installing GNOME extensions..."
for extension in "${GNOME_EXTENSIONS[@]}"; do
    # Extract extension ID and name from the comment
    extension_id=$(echo "$extension" | cut -d'#' -f1 | xargs)
    extension_name=$(echo "$extension" | cut -d'#' -f2 | xargs)
    
    if [ -z "$extension_name" ]; then
        extension_name="$extension_id"
    fi
    
    install_gnome_extension "$extension_id" "$extension_name"
done

echo ""
echo "GNOME extensions setup completed!"
echo "Note: Some extensions may need to be installed manually from https://extensions.gnome.org"
echo "After installation, you may need to log out and log back in for extensions to work properly."