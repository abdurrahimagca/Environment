#!/bin/bash

if [ -f /etc/os-release ]; then
    source /etc/os-release
    DISTRO=$ID
    echo "Detected OS: $PRETTY_NAME"
else
    echo "Could not detect OS information."
    exit 1
fi

case "$DISTRO" in
    ubuntu|debian|linuxmint|pop) 
        export PKG_MGR="apt"
        export INSTALL_CMD="sudo apt update && sudo apt install -y"
        ;;
    fedora|rocky|almalinux) 
        export PKG_MGR="dnf"
        export INSTALL_CMD="sudo dnf install -y"
        ;;
    centos|rhel)
        if command -v dnf >/dev/null; then
            export PKG_MGR="dnf"
            export INSTALL_CMD="sudo dnf install -y"
        else
            export PKG_MGR="yum"
            export INSTALL_CMD="sudo yum install -y"
        fi
        ;;
    arch|manjaro)
        export PKG_MGR="pacman"
        export INSTALL_CMD="sudo pacman -Sy --needed"
        ;;
    opensuse|sles)
        export PKG_MGR="zypper"
        export INSTALL_CMD="sudo zypper install -y"
        ;;
    *)
        echo "Unsupported OS: $DISTRO"
        exit 1
        ;;
esac

echo "Detected package manager: $PKG_MGR"
