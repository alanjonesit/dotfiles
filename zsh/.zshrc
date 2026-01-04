# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# ENVIRONMENT VARIABLES - https://zsh.sourceforge.io/Guide/zshguide02.html
# ============================================================================

export GPG_TTY=$(tty)                                     # For GPG commit signing
export XDG_CONFIG_HOME=~/.config                          # Standard config location
export TERM=xterm-256color                                # Proper color support
export PATH="/opt/homebrew/opt/curl/bin:$PATH"            # Homebrew curl
export TERMINAL="ghostty"                                 # Set Ghostty as default terminal

# zsh-abbr configuration
export ABBR_USER_ABBREVIATIONS_FILE="${ZDOTDIR:-$HOME/.config/zsh}/zsh-abbr/user-abbreviations"


# ============================================================================
# AUTOLOADS - https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html
# ============================================================================

autoload run-help
unalias run-help 2>/dev/null  # Remove default alias to man


# ============================================================================
# ZSH PARAMETERS - https://zsh.sourceforge.io/Doc/Release/Parameters.html
# ============================================================================

HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"   # File to save history in when shell exits
HISTSIZE=1100000000                         # Maximum events stored in internal history list
SAVEHIST=1000000000                         # Maximum events to save in history file


# ============================================================================
# ZSH OPTIONS - https://zsh.sourceforge.io/Doc/Release/Options.html
# ============================================================================

# Completion
setopt always_to_end        # Move cursor to end after completion
setopt auto_menu            # Show menu on repeated tab
setopt complete_in_word     # Complete from both ends of word
unsetopt list_beep          # No beep on ambiguous completion
unsetopt menu_complete      # Don't autoselect first completion

# Directory navigation
setopt auto_cd              # Type directory name to cd
setopt auto_pushd           # Make cd push to directory stack
setopt pushd_minus          # Use - for older dirs (matches git)

# History
setopt hist_expire_dups_first  # When trimming history, lose oldest duplicate first
setopt hist_find_no_dups       # Don't display duplicates when searching history
setopt hist_ignore_space       # Don't save commands starting with space
setopt share_history           # Import new commands & append typed commands to history file

# Input/Output
unsetopt flow_control       # Disable Ctrl-S/Ctrl-Q flow control
setopt interactivecomments  # Allow comments in interactive shell

# Prompting
setopt prompt_subst         # Enable prompt substitution


# ============================================================================
# ZSH ZLE (LINE EDITOR) - https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html
# ============================================================================

zle_highlight=('paste:none')  # Disable paste highlighting


# ============================================================================
# CUSTOM FUNCTIONS
# ============================================================================

# Yazi file manager - changes directory on quit - https://github.com/sxyazi/yazi
# Press 'q' to quit and cd, 'Q' to quit without cd
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# ============================================================================
# ZIM FRAMEWORK - https://github.com/zimfw/zimfw
# ============================================================================

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source /opt/homebrew/opt/zimfw/share/zimfw.zsh init -q
fi

# Initialize modules
source ${ZIM_HOME}/init.zsh

# ============================================================================
# COMPLETION INITIALIZATION
# ============================================================================
# Initialize completion system manually (instead of using zim's completion module)

autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"

# ============================================================================
# ZSH ZSTYLE (COMPLETION SYSTEM) - https://zsh.sourceforge.io/Doc/Release/Completion-System.html
# ============================================================================

# Completion cache location
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache

# Case insensitive, dash/underscore insensitive completion matching
typeset -A match_specifications=(
  [any_before_any]='r:|?=**'
  [any_before_dot]='r:|[.]=**'
  [any_before_word]='l:|=*'
  [case_and_dash_insensitive]='m:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}'
  [nonseparators_after_any_before_separator]='r:?||[-_ \]=*'
  [separator_after_any]='l:?|=[-_ \]'
)
zstyle ':completion:*' matcher-list \
    "$match_specifications[case_and_dash_insensitive] $match_specifications[any_before_dot] $match_specifications[any_before_word]" \
    "+$match_specifications[nonseparators_after_any_before_separator] $match_specifications[separator_after_any]" \
    "$match_specifications[case_and_dash_insensitive] $match_specifications[any_before_any]"
unset match_specifications

zstyle ':completion:*' menu select              # Show completion menu
zstyle ':completion::complete:*' use-cache yes  # Enable completion caching

# ============================================================================
# EXTERNAL TOOL INTEGRATIONS
# ============================================================================
# Note: These must come after zimfw init to avoid duplicate compinit calls

eval "$(atuin init zsh)"                              # Atuin: Shell history manager - https://atuin.sh

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # Carapace: Completion generator - https://carapace.sh
zstyle ':completion:*' format $'%{\e[2;37m%}-- %d --%{\e[0m%}'
source <(carapace _carapace)

source <(fzf --zsh)                                   # fzf: Fuzzy finder - https://github.com/junegunn/fzf
eval "$(zoxide init zsh)"                             # zoxide: Smart cd - https://github.com/ajeetdsouza/zoxide

# VS Code shell integration - https://code.visualstudio.com/docs/terminal/shell-integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Load Powerlevel10k configuration
# Run 'p10k configure' to customise your prompt
[[ ! -f ~/.config/zsh/p10k/.p10k.zsh ]] || source ~/.config/zsh/p10k/.p10k.zsh

# ============================================================================
# ALIASES
# ============================================================================

# General shortcuts
alias c="clear"

# Config file shortcuts
alias zshconfig="code ~/.config/zsh/.zshrc"
alias zimconfig="code ~/.config/zsh/.zimrc"
alias ghosttyconfig="code ~/.config/ghostty/config"
alias p10kconfig="code ~/.config/zsh/p10k/.p10k.zsh"

# Better defaults with modern tools
alias ls="eza --icons --group-directories-first"
alias ll="eza --icons --group-directories-first -lah"
alias cat="bat --paging=never"
alias cd="z"

# Python
alias python=python3


# ============================================================================
# NOTES
# ============================================================================
#
# Tools installed:
# - zimfw: Fast, modular zsh framework and plugin manager
# - Powerlevel10k: Beautiful, fast prompt with transient prompt feature
# - eza: Modern replacement for ls
# - bat: Modern replacement for cat with syntax highlighting
# - zoxide: Smarter cd that learns your habits
# - fzf: Fuzzy finder for files and history
# - yazi: Terminal file manager
# - zsh-syntax-highlighting: Highlights commands as you type
# - zsh-autosuggestions: Suggests commands from history
# - zsh-abbr: Fish-like abbreviations (type shortcut + space to expand)
#
# Quick tips:
# - Press Ctrl+R for fzf history search
# - Type 'z <partial-path>' to jump to frequently used directories
# - Type 'y' to open yazi file manager
# - Run 'p10k configure' to customise your prompt
# - Enable transient prompt in p10k config for cleaner scrollback
# - Use 'abbr' to manage abbreviations (e.g., 'abbr gc="git commit"')
#   Then type 'gc ' and it expands to 'git commit '
# - Run 'zimfw install' after updating ~/.zimrc to install new modules
# - Run 'zimfw update' to update all modules to latest versions
# - Run 'zimfw uninstall' to remove modules no longer in ~/.zimrc
#
# Configuration structure and many option explanations inspired by:
# https://olets.dev/posts/my-zshrc-zsh-configuration-annotated/
#
# ============================================================================
