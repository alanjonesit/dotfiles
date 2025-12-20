# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

### macOS

First, install [Homebrew](https://brew.sh/) if you don't have it:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then install [Git](https://git-scm.com/) and [GNU Stow](https://www.gnu.org/software/stow/):

```bash
brew install git stow
```

### Linux (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install git stow  # Git and GNU Stow
```

## Installation

Clone this repository to your home directory:

```bash
git clone git@github.com:alanjonesit/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The setup script will:

- Create `~/.zshenv` to point zsh to `~/.config/zsh`
- Create `~/.hushlogin` to suppress login messages
- Symlink all config folders to `~/.config/`

Restart your terminal or run `exec zsh` to apply changes.

## How it works

Each app has its own folder (zsh, ghostty, atuin, etc.). The `.stowrc` file tells Stow to create symlinks in `~/.config/`:

```txt
~/.config/zsh → ~/dotfiles/zsh
~/.config/ghostty → ~/dotfiles/ghostty
~/.config/p10k → ~/dotfiles/p10k
```

## Uninstallation

Remove symlinks:

```bash
cd ~/dotfiles
stow -D .
rm ~/.zshenv ~/.hushlogin
```
