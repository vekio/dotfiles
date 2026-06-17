#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="${DOTFILES_SOURCE:-$(chezmoi source-path)}"
source "$ROOT/scripts/lib.sh"

require_fedora

PACKAGES_FILE="${DNF_PACKAGES_FILE:-$ROOT/packages/fedora/dnf.txt}"

title "DNF apps"
info "Instalando paquetes desde $PACKAGES_FILE"

run sudo dnf upgrade --refresh -y
dnf_install_packages_from_file "$PACKAGES_FILE"

success "DNF apps instalado"


