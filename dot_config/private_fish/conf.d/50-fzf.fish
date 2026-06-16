if not status is-interactive
    return
end

if command -q fzf
    set -gx FZF_DEFAULT_OPTS '
        --height=40%
        --layout=reverse
        --border
        --cycle
        --info=inline
    '

    set -gx FZF_CTRL_T_OPTS '
        --preview "bat --style=numbers --color=always --line-range :200 {} 2>/dev/null"
    '

    fzf --fish | source
end
