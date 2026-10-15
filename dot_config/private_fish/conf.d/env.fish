fish_add_path --global "$HOME/.local/bin" "$HOME/bin"

set -gx EDITOR nvim
set -gx VISUAL nvim

if command -q xdg-user-dir
    set -gx XDG_PROJECTS_DIR (xdg-user-dir PROJECTS)
end

set -gx GOPATH "$HOME/.local/share/go"
set -gx GOBIN "$GOPATH/bin"
fish_add_path --global "$GOBIN"

if command -q gpgconf
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end
