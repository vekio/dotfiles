fish_add_path --global "$HOME/.local/bin" "$HOME/bin"

set -gx GOPATH "$HOME/.local/share/go"
set -gx GOBIN "$GOPATH/bin"
fish_add_path --global "$GOBIN"

if command -q gpgconf
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end
