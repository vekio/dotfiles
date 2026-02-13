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
# Open chezmoi source in Codium (no cd required).
alias dotfiles='code "$(chezmoi source-path)"'

# Use from toolbox (workaround: flatpak-spawn + alias).
alias podman='host-podman'
