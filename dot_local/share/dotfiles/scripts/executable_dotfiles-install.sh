#!/usr/bin/env bash
#
# Main dotfiles installer. It lives with the internal installer scripts and is
# exposed on PATH through ~/.local/bin/dotfiles-install.

set -Eeuo pipefail

if ! command -v chezmoi >/dev/null 2>&1; then
  echo "ERROR: chezmoi is not installed" >&2
  exit 1
fi

DOTFILES_SOURCE="${DOTFILES_SOURCE:-$(chezmoi source-path)}"
DOTFILES_HOME="${DOTFILES_HOME:-$HOME/.local/share/dotfiles}"
DOTFILES_SCRIPTS="${DOTFILES_SCRIPTS:-$DOTFILES_HOME/scripts}"
DOTFILES_PACKAGES="${DOTFILES_PACKAGES:-$DOTFILES_HOME/packages}"

export DOTFILES_SOURCE DOTFILES_HOME DOTFILES_SCRIPTS DOTFILES_PACKAGES

# During bootstrap, this command may run from the chezmoi source tree before
# ~/.local/share/dotfiles exists. Prefer installed scripts, then fall back to
# the source-state path.
if [ -f "$DOTFILES_SCRIPTS/lib.sh" ]; then
  source "$DOTFILES_SCRIPTS/lib.sh"
else
  source "$DOTFILES_SOURCE/dot_local/share/dotfiles/scripts/lib.sh"
fi

title "Dotfiles install"
info "Source: $DOTFILES_SOURCE"

run chezmoi apply

run_script "$DOTFILES_SCRIPTS/05-fedora-repos.sh"
run_script "$DOTFILES_SCRIPTS/10-dnf-apps.sh"
run_script "$DOTFILES_SCRIPTS/20-flatpak-apps.sh"
run_script "$DOTFILES_SCRIPTS/30-mise-tools.sh"

success "Install complete"
