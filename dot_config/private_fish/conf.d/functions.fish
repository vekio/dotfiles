if not status is-interactive
    return
end

function mkcd
    test (count $argv) -eq 1; or return 2
    mkdir -p -- $argv[1]; and cd -- $argv[1]
end
