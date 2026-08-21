#!/usr/bin/env bash

# Prepare a Fedora workstation, apply the dotfiles, and hand off provisioning
# to ~/.local/bin/dotfiles-install. Keep this file self-contained because it can
# run before the repository exists.

set -Eeuo pipefail

repo="https://git.casta.me/alberto/dotfiles_new.git"
branch="main"

fail() {
  printf '\033[1;31mERROR\033[0m  %s\n' "$*" >&2
  exit 1
}

command -v sudo >/dev/null 2>&1 || fail "sudo is not installed"
command -v dnf >/dev/null 2>&1 || fail "dnf is not installed"

printf 'Installing bootstrap dependencies\n'
sudo dnf install -y ca-certificates curl git chezmoi

source_dir="$(chezmoi source-path)"
if [ -d "$source_dir/.git" ]; then
  printf 'Applying existing chezmoi source state\n'
  chezmoi apply
else
  printf 'Initializing dotfiles from %s\n' "$repo"
  chezmoi init --apply --branch "$branch" "$repo"
fi

installer="$HOME/.local/bin/dotfiles-install"
[ -x "$installer" ] || fail "Installer was not created by chezmoi: $installer"
"$installer"

printf '\033[1;32mOK\033[0m  Bootstrap complete\n'
