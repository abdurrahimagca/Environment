#!/usr/bin/env bash

# Source the OS detection script
source "$(dirname "$0")/00-detect-os.sh"

# Get the config directory
SCRIPT_DIR="$(dirname "$(dirname "$0")")"
CONFIG_DIR="$SCRIPT_DIR/config"

echo "Setting up dotfiles..."

# Apply Git configuration
if [ -f "$CONFIG_DIR/gitconfig.conf" ]; then
    echo "Applying Git configuration..."
    cp "$CONFIG_DIR/gitconfig.conf" "$HOME/.gitconfig"
    echo "Git configuration applied"
fi

# Apply Tmux configuration
if [ -f "$CONFIG_DIR/tmux.conf" ]; then
    echo "Applying Tmux configuration..."
    cp "$CONFIG_DIR/tmux.conf" "$HOME/.tmux.conf"
    echo "Tmux configuration applied"
fi

# Create vim/nvim config directory and basic config
mkdir -p "$HOME/.config/nvim"
if [ ! -f "$HOME/.config/nvim/init.vim" ]; then
    echo "Creating basic Neovim configuration..."
    cat > "$HOME/.config/nvim/init.vim" << 'EOF'
" Basic Neovim configuration
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set wrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set signcolumn=yes
set colorcolumn=80

" Enable syntax highlighting
syntax on

" Set colorscheme
colorscheme desert

" Basic key mappings
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Easy window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
EOF
    echo "Basic Neovim configuration created"
fi

# Create SSH directory with proper permissions
mkdir -p "$HOME/.ssh" 
chmod 700 "$HOME/.ssh"

# Create basic SSH config
if [ ! -f "$HOME/.ssh/config" ]; then
    echo "Creating basic SSH configuration..."
    cat > "$HOME/.ssh/config" << 'EOF'
# SSH Configuration
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60
    ServerAliveCountMax 3
EOF
    chmod 600 "$HOME/.ssh/config"
    echo "SSH configuration created"
fi

echo "Dotfiles setup completed!"