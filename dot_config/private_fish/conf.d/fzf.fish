if not status is-interactive
    return
end

if not command -q fzf
    return
end

set -gx FZF_DEFAULT_OPTS '
    --height=40%
    --layout=reverse
    --border
    --cycle
    --info=inline
'

if command -q fd
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
end

if command -q bat
    set -gx FZF_CTRL_T_OPTS '
        --preview "bat --style=numbers --color=always --line-range :200 {} 2>/dev/null"
    '
end

fzf --fish | source
