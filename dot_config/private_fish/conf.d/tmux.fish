if not status is-interactive
    return
end

if set -q TMUX
    return
end

if not command -q tmux
    return
end

if set -q TERM_PROGRAM
    switch $TERM_PROGRAM
        case vscode zed
            return
    end
end

tmux new-session -A -s main
