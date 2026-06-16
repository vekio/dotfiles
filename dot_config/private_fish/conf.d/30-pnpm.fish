set -gx PNPM_HOME "$HOME/.local/share/pnpm"

if not contains "$PNPM_HOME/bin" $PATH
    fish_add_path "$PNPM_HOME/bin"
end
