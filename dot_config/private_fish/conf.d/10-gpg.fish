if command -q gpgconf
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

    if status is-interactive
        gpgconf --launch gpg-agent >/dev/null 2>&1
    end
end
