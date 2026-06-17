#!/usr/bin/env bash
#
# Install workstation Flatpak applications from the dotfiles package list.
# The script is safe to re-run: it keeps Flathub configured and skips apps that
# are already installed.

set -Eeuo pipefail

ROOT="${DOTFILES_SOURCE:-$(chezmoi source-path)}"
SCRIPTS="${DOTFILES_SCRIPTS:-$HOME/.local/share/dotfiles/scripts}"
PACKAGES="${DOTFILES_PACKAGES:-$HOME/.local/share/dotfiles/packages}"
source "$SCRIPTS/lib.sh"

# This package list and repository setup are Fedora-specific.
require_fedora

PACKAGES_FILE="${FLATPAK_PACKAGES_FILE:-$PACKAGES/fedora/flatpak.txt}"

title "Flatpak apps"

# Flatpak is a base dependency for this step, not part of the app list itself.
if ! has flatpak; then
  info "Installing flatpak"
  run sudo dnf install -y flatpak
fi

# Keep Flatpak apps system-wide so the workstation state is not tied to a
# per-user Flatpak remote.
info "Configuring Flathub"
run sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Package files support comments and blank lines.
mapfile -t apps < <(read_package_file "$PACKAGES_FILE")

if [ "${#apps[@]}" -eq 0 ]; then
  warn "No Flatpak apps in $PACKAGES_FILE"
  exit 0
fi

# Install only missing apps so this script can be re-run after partial failure.
for app in "${apps[@]}"; do
  if flatpak info --system "$app" >/dev/null 2>&1; then
    detail "Already installed: $app"
  else
    detail "Installing: $app"
    run sudo flatpak install -y --system flathub "$app"
  fi
done

success "Flatpak apps installed"
