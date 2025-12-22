#!/bin/bash

set -e

echo "Setting up dotfiles..."
cd "$(dirname "$0")"

# Check for Homebrew and install if needed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        # shellcheck disable=SC2016
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo ""
fi

# Optional: Install Homebrew packages first
if [ -f "Brewfile" ]; then
    echo ""
    read -p "Install Homebrew packages from Brewfile? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing Homebrew packages..."
        brew bundle install
        echo ""
    fi
fi

# Create .zshenv in home directory
echo "Creating ~/.zshenv..."
cat > ~/.zshenv << 'EOF'
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
EOF

# Create .hushlogin to suppress login message
echo "Creating ~/.hushlogin..."
touch ~/.hushlogin

# Stow all configurations
echo "Stowing configurations to ~/.config..."
stow .

# Install Zim framework modules
echo "Installing Zim framework modules..."
zsh -c "source ~/.zshenv && ZIM_HOME=\${ZDOTDIR:-\${HOME}}/.zim source /opt/homebrew/opt/zimfw/share/zimfw.zsh install"
echo ""

echo ""
echo "✓ Dotfiles setup complete!"
echo "Restarting shell..."
echo ""
exec zsh
