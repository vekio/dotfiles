# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS

# -----------------------------------------------------------------------------
# Quality of life
# -----------------------------------------------------------------------------
setopt AUTO_CD           # cd into directories by typing their name
setopt CORRECT           # minor typo correction for commands
# setopt CORRECT_ALL     # uncomment if you want correction for args too (can be annoying)

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# -----------------------------------------------------------------------------
# Completion menu
# -----------------------------------------------------------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''

# -----------------------------------------------------------------------------
# Keybindings
# -----------------------------------------------------------------------------
#bindkey '^R' history-incremental-search-backward

# Bind: ctrl+e acepta autosuggest (requiere autosuggestions)
bindkey '^e' autosuggest-accept
