#!/usr/bin/env bash

# Source the OS detection script
source "$(dirname "$0")/00-detect-os.sh"

echo "Setting up development environment..."

# Install NVM and Node.js
echo "Setting up Node.js with NVM..."
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    
    # Source NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install latest LTS Node.js
    echo "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    
    # Install global packages
    echo "Installing global npm packages..."
    npm install -g yarn pnpm typescript ts-node nodemon
else
    echo "NVM is already installed"
fi

# Setup Python development environment
echo "Setting up Python development environment..."
if command -v python3 >/dev/null; then
    echo "Installing Python development packages..."
    python3 -m pip install --user --upgrade pip
    python3 -m pip install --user virtualenv pipenv poetry
    
    # Create a default virtual environment
    if [ ! -d "$HOME/.venvs" ]; then
        mkdir -p "$HOME/.venvs"
        echo "Creating default Python virtual environment..."
        python3 -m venv "$HOME/.venvs/default"
    fi
else
    echo "Python3 not found, skipping Python setup"
fi

# Setup Go environment
echo "Setting up Go environment..."
if command -v go >/dev/null; then
    echo "Setting up Go workspace..."
    mkdir -p "$HOME/go/src" "$HOME/go/bin" "$HOME/go/pkg"
    
    # Add Go paths to environment (will be in zshrc)
    echo "Go workspace created at $HOME/go"
else
    echo "Go not found, skipping Go setup"
fi

# Setup Docker (if installed)
echo "Configuring Docker..."
if command -v docker >/dev/null; then
    echo "Adding user to docker group..."
    sudo usermod -aG docker $USER
    echo "Docker configured. You may need to log out and back in for group changes to take effect."
else
    echo "Docker not found, skipping Docker setup"
fi

# Setup Git global configuration
echo "Setting up Git configuration..."
if command -v git >/dev/null; then
    echo "Please enter your Git configuration:"
    read -p "Git username: " git_username
    read -p "Git email: " git_email
    
    if [ -n "$git_username" ] && [ -n "$git_email" ]; then
        git config --global user.name "$git_username"
        git config --global user.email "$git_email"
        git config --global init.defaultBranch main
        git config --global pull.rebase true
        git config --global core.autocrlf input
        echo "Git configured successfully"
    else
        echo "Git configuration skipped"
    fi
else
    echo "Git not found, skipping Git setup"
fi

# Create common development directories
echo "Creating development directories..."
mkdir -p "$HOME/Projects" "$HOME/bin" "$HOME/.local/bin"

echo "Development environment setup completed!"
echo "Note: You may need to restart your terminal or log out/in for all changes to take effect."