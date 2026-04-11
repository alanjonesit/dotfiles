# Overrides applied on top of the upstream p10k-lean.zsh template.
# Source order in .zshrc: upstream lean template first, then this file.

# Move aws to left prompt (after vcs), remove it from right prompt.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir
  vcs
  aws
  newline
  prompt_char
)

# Nerd Font v3 icon set (wizard-selected).
typeset -g POWERLEVEL9K_MODE=nerdfont-v3

# Filler/ruler foreground color.
typeset -g POWERLEVEL9K_RULER_FOREGROUND=242
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=242

# Disable DIR_CLASSES (no per-directory color customization).
typeset -g POWERLEVEL9K_DIR_CLASSES=()

# Hide git icon.
typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=

# Show execution time for all commands, with 1 decimal place.
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=

# Hide version manager segments when using the system version.
typeset -g POWERLEVEL9K_ASDF_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_GOENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_NODENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_NVM_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_RBENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_LUAENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_JENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_PLENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_PHPENV_SHOW_SYSTEM=false
typeset -g POWERLEVEL9K_SCALAENV_SHOW_SYSTEM=false

# Extended AWS show-on-command list (awsp, tfbackend added).
typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awsp|awless|cdk|terraform|tofu|tfbackend|pulumi|terragrunt'

# Hide time icon.
typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=

# Always show transient prompt.
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
