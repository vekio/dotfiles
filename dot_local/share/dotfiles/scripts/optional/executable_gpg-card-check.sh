#!/usr/bin/env bash
#
# Prepare and check GPG smartcard/YubiKey access.
# This is safe to re-run and does not change keys, trust, LUKS, or card data.

set -Eeuo pipefail

SCRIPTS="${DOTFILES_SCRIPTS:-$HOME/.local/share/dotfiles/scripts}"
source "$SCRIPTS/lib.sh"

require_fedora

title "GPG smartcard"

has systemctl || fail "systemctl is not available"
has gpgconf || fail "gpgconf is not installed"
has gpg || fail "gpg is not installed"

# pcscd.socket is the stable way to expose the YubiKey smartcard interface.
detail "Enabling pcscd.socket"
run sudo systemctl enable --now pcscd.socket

# Restart only the user GnuPG agents so they reload scdaemon.conf.
detail "Restarting GnuPG agents"
run gpgconf --kill scdaemon
run gpgconf --kill gpg-agent

detail "pcscd.socket: $(systemctl is-active pcscd.socket || true)"
detail "pcscd.service: $(systemctl is-active pcscd.service || true)"

info "Checking OpenPGP card"
run gpg --card-status

success "GPG smartcard check complete"
