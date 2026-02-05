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

# -----------------------------------------------------------------------------
# Tooling
# -----------------------------------------------------------------------------
# Use toolbox remote for podman inside containers.
alias podman='podman-remote'

# Open chezmoi source in Codium (no cd required).
alias dotfiles='codium "$(chezmoi source-path)"'
