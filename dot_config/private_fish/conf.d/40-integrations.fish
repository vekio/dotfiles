if not status is-interactive
    return
end

if command -q direnv
    direnv hook fish | source
end

if command -q mise
    mise activate fish | source

    if command -q usage
        mise completion fish | source
    end
end

if command -q vek
    vek completion fish | source
end

if command -q starship
    starship init fish | source
end
