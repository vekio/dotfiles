if not status is-interactive
    return
end

# GPG
if command -q gpgconf
    gpgconf --launch gpg-agent >/dev/null 2>&1
end

# Environment
if command -q direnv
    direnv hook fish | source
end

if command -q mise
    mise activate fish | source

    if command -q usage
        mise completion fish | source
    end
end

# Completions
if command -q vek
    vek completion fish | source
end

if command -q overmind
    overmind completion fish | source
end

if command -q pkm
    pkm completion fish | source
end

# Prompt
if command -q starship
    starship init fish | source
end
