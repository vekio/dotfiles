# -----------------------------------------------------------------------------
# Navigation
# -----------------------------------------------------------------------------
alias dl='cd ~/Downloads'
alias docs='cd ~/Documents'
alias src='cd ~/Source'

# Quick directory jumps
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# -----------------------------------------------------------------------------
# Listing
# -----------------------------------------------------------------------------
alias l='ls -lh'
alias ll='ls -alh'
alias la='ls -Ahl'
alias ls='ls --color=auto'

# -----------------------------------------------------------------------------
# Tooling
# -----------------------------------------------------------------------------
alias code='codium'
# Open chezmoi source in Codium (no cd required).
alias dotfiles='code "$(chezmoi source-path)"'
