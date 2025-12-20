#!/bin/bash

set -e

echo "Setting up dotfiles..."

# Create .zshenv in home directory
echo "Creating ~/.zshenv..."
cat > ~/.zshenv << 'EOF'
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
EOF

# Stow all configurations
echo "Stowing configurations to ~/.config..."
cd "$(dirname "$0")"
stow .

echo "✓ Dotfiles setup complete!"
echo ""
echo "Please restart your terminal or run: exec zsh"
