#!/usr/bin/env bash

set -Eeuo pipefail

readonly REPOSITORY="https://git.casta.me/alberto/dotfiles.git"
readonly BRANCH="main"

info() {
  printf '\033[1;34m==>\033[0m %s\n' "$*"
}

die() {
  printf '\033[1;31mERROR\033[0m %s\n' "$*" >&2
  exit 1
}

[[ -r /etc/os-release ]] || die "Missing /etc/os-release"
# shellcheck disable=SC1091
. /etc/os-release
[[ "${ID:-}" == "fedora" ]] || die "Unsupported OS: ${ID:-unknown}"

command -v dnf >/dev/null || die "dnf is not installed"
command -v sudo >/dev/null || die "sudo is not installed"

info "Installing bootstrap packages"
sudo dnf install -y ca-certificates curl git chezmoi

source_dir="$(chezmoi source-path)"
if [[ -d "$source_dir/.git" ]]; then
  info "Applying existing dotfiles"
  chezmoi apply
else
  info "Initializing dotfiles"
  chezmoi init --apply --branch "$BRANCH" "$REPOSITORY"
fi

installer="$HOME/.local/bin/dotfiles-install"
[[ -x "$installer" ]] || die "Installer not found: $installer"

"$installer"
printf '\033[1;32mOK\033[0m Bootstrap complete\n'
