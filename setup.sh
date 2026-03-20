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

        # Configure brew autoupdate
        echo "Configuring brew autoupdate..."
        brew autoupdate start 43200 --upgrade --cleanup --immediate --sudo
        echo ""
    fi
fi

# Install DeskRest
echo "Installing DeskRest..."
DESKREST_DMG="/tmp/DeskRest.dmg"
# Get latest release download URL from GitHub API
DESKREST_URL=$(curl -s https://api.github.com/repos/Marceeelll/DeskRest-releases/releases/latest | grep -o '"browser_download_url": "[^"]*\.dmg"' | cut -d'"' -f4 | head -1)
if [ -n "$DESKREST_URL" ]; then
    curl -L "$DESKREST_URL" -o "$DESKREST_DMG" 2>/dev/null
    if [ -f "$DESKREST_DMG" ]; then
        hdiutil attach "$DESKREST_DMG" -nobrowse -quiet
        cp -r /Volumes/DeskRest/DeskRest.app /Applications/ 2>/dev/null || true
        hdiutil detach /Volumes/DeskRest -quiet
        rm -f "$DESKREST_DMG"
        echo "✓ DeskRest installed"
    else
        echo "⚠ Failed to download DeskRest. Skipping."
    fi
else
    echo "⚠ Could not find DeskRest download link. Skipping."
fi
echo ""

# Create .zshenv in home directory
echo "Creating ~/.zshenv..."
cat > ~/.zshenv << 'EOF'
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
EOF

# Create .hushlogin to suppress login message
echo "Creating ~/.hushlogin..."
touch ~/.hushlogin

# Ensure ~/.config directory exists
mkdir -p ~/.config

# Stow all configurations
echo "Stowing configurations to ~/.config..."
stow .

# Install Zim framework modules
echo "Installing Zim framework modules..."
zsh -c "source ~/.zshenv && ZIM_HOME=\${ZDOTDIR:-\${HOME}}/.zim source /opt/homebrew/opt/zimfw/share/zimfw.zsh install"
echo ""

# Git configuration
echo "Git configuration"
echo "-----------------"

read -rp "Enter your git name: " git_name
while [[ -z "$git_name" ]]; do
    echo "  ✗ Name cannot be empty."
    read -rp "Enter your git name: " git_name
done

while true; do
    read -rp "Enter your git email address: " git_email
    if [[ "$git_email" == *"@"*"."* ]]; then
        break
    else
        echo "  ✗ That doesn't look like a valid email, try again."
    fi
done

git config --global user.name "$git_name"
git config --global user.email "$git_email"
echo ""
echo "Git identity:"
echo "  Name:  $(git config --global user.name)"
echo "  Email: $(git config --global user.email)"
echo ""

echo ""
echo "✓ Dotfiles setup complete!"
echo ""
echo "⚠ You'll need to do the following manually:"
echo "- Configure Mac system settings"
echo " - Sign in to Visual Studio Code"
echo " - Add license keys to:"
echo "     - Shottr"
echo "     - DeskRest"
echo "     - BetterMouse"
echo ""
echo "Restarting shell..."
echo ""
exec zsh
