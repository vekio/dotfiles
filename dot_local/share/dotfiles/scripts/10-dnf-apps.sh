#!/usr/bin/env bash
#
# Install Fedora RPM packages from the dotfiles package list.

set -Eeuo pipefail

SCRIPTS="${DOTFILES_SCRIPTS:-$HOME/.local/share/dotfiles/scripts}"
PACKAGES="${DOTFILES_PACKAGES:-$HOME/.local/share/dotfiles/packages}"
source "$SCRIPTS/lib.sh"

require_fedora

PACKAGES_FILE="${DNF_PACKAGES_FILE:-$PACKAGES/fedora/dnf.txt}"

title "DNF apps"
info "Package file: $PACKAGES_FILE"

run sudo dnf upgrade --refresh -y
dnf_install_packages_from_file "$PACKAGES_FILE"

success "DNF apps installed"
