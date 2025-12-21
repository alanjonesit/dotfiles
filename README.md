# Dotfiles

My personal macOS development environment setup, featuring automated installation, declarative package management with [Homebrew](https://brew.sh/), and organized configuration files with [GNU Stow](https://www.gnu.org/software/stow/).

## Getting Started

### Installation

Clone this repository to your home directory and run the setup script:

```bash
git clone git@github.com:alanjonesit/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The setup script will:

- Install Homebrew (if not already installed)
- Optionally install all packages from `Brewfile` (includes stow, git, zsh tools, etc.)
- Create `~/.zshenv` to point zsh to `~/.config/zsh`
- Create `~/.hushlogin` to suppress login messages
- Symlink all config folders to `~/.config/`
- Install [Zim](https://zimfw.sh/) framework modules ([Powerlevel10k](https://github.com/romkatv/powerlevel10k), plugins, etc.)

Restart your terminal or run `exec zsh` to apply changes.

> **Works on Linux too!** The setup script and Brewfile are cross-platform compatible.

### What's Included

- **Package management:** The [`Brewfile`](Brewfile) declares all CLI tools, GUI applications, and fonts

- **Stow symlinks:** The `.stowrc` file targets `~/.config`, so Stow creates symlinks:

  ```txt
  ~/.config/zsh → ~/dotfiles/zsh
  ~/.config/ghostty → ~/dotfiles/ghostty
  ~/.config/atuin → ~/dotfiles/atuin
  ```

- **Zsh configuration:** `~/.zshenv` sets `ZDOTDIR` to move all zsh files to `~/.config/zsh`, keeping your home directory clean.

## Usage

### Managing Packages

The `Brewfile` contains all Homebrew packages, casks, and Mac App Store apps.

**Update Brewfile with current installations:**

```bash
brew bundle dump --file=~/dotfiles/Brewfile --force
```

**Install packages on a new machine:**

```bash
brew bundle install
```

### How It Works

Because Stow creates **symlinks**, when you edit `~/.config/zsh/.zshrc`, you're actually editing `~/dotfiles/zsh/.zshrc` directly. Changes are immediately reflected in git - no re-stowing needed!

The Brewfile declares all CLI tools, applications, and fonts, making it easy to replicate your setup on any Mac or Linux machine.

**When to run stow commands:**

- **Adding new config folders:** `stow .` to create new symlinks
- **Removing config folders:** `stow -D . && stow .` to recreate without removed folders
- **Editing existing files:** No stow needed - files are already linked!

## Uninstallation

To completely remove the dotfiles setup:

```bash
# Remove all symlinks
cd ~/dotfiles
stow -D .

# Remove created files
rm ~/.zshenv ~/.hushlogin

# Optional: Remove the repository
cd ~
rm -rf ~/dotfiles
```

Your packages will remain installed. To remove them:

```bash
brew bundle cleanup --file=~/dotfiles/Brewfile --force
```
