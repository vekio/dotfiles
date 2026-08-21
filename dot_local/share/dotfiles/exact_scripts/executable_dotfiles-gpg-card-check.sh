#!/usr/bin/env bash

set -Eeuo pipefail

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

command -v systemctl >/dev/null 2>&1 || fail "systemctl is not available"
command -v gpgconf >/dev/null 2>&1 || fail "gpgconf is not installed"
command -v gpg >/dev/null 2>&1 || fail "gpg is not installed"

systemctl is-active --quiet pcscd.socket || \
  fail "pcscd.socket is not active. Run: sudo systemctl enable --now pcscd.socket"

printf 'Restarting GnuPG agents\n'
gpgconf --kill scdaemon
gpgconf --kill gpg-agent

gpg --card-status
