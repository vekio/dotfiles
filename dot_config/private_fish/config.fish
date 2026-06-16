if status is-interactive
    # gpg
    if command -q gpgconf
        set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        gpgconf --launch gpg-agent >/dev/null 2>&1
    end

    # direnv
    if command -q direnv
        direnv hook fish | source
    end

    # mise
    if command -q mise
        mise activate fish | source
    end

    # vek
    if command -q vek
        vek completion fish | source
    end

    # starship
    if command -q starship
        starship init fish | source
    end
end
