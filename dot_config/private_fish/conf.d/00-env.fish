# User paths
fish_add_path --global "$HOME/.local/bin"
fish_add_path --global "$HOME/bin"

# Go
set -gx GOPATH "$HOME/.local/share/go"
set -gx GOBIN "$GOPATH/bin"
fish_add_path --global "$GOBIN"

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path --global "$PNPM_HOME"
