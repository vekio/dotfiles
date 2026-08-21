if not status is-interactive
    return
end

# Navigation
alias dl='cd ~/Downloads'
alias docs='cd ~/Documents'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Listing
alias ls='ls --color=auto'
alias l='ls -lh'
alias ll='ls -Ahl'

# Tools
alias reload='exec fish'
alias dotfiles='zed (chezmoi source-path)'
alias path='printf "%s\n" $PATH'
