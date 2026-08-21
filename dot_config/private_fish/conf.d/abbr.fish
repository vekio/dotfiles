if not status is-interactive
    return
end

# Zed
abbr -a e 'zed .'

# Git
abbr --command git st status
abbr --command git sw switch
abbr --command git aa 'add --all'
abbr --command git ci commit
abbr --command git ps push
abbr --command git br branch
abbr --command git df diff
abbr --command git rb rebase
abbr --command git sh show

# Tools
abbr -a j 'just'
abbr -a v 'vek'
abbr -a ov 'overmind'
abbr -a ws 'workstation'
