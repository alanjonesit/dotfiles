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
```

Use stow to symlink configurations:

```bash
# Install all configurations
stow .
```

## Uninstallation

Remove symlinks:

```bash
stow -D .
```
