#!/usr/bin/env bash

set -Eeuo pipefail

readonly PACKAGE_DIR="$HOME/.local/share/dotfiles/packages/fedora"
readonly MISE_PATH="$HOME/.local/bin/mise"

info() {
  printf '\033[1;34m==>\033[0m %s\n' "$*"
}

die() {
  printf '\033[1;31mERROR\033[0m %s\n' "$*" >&2
  exit 1
}

load_packages() {
  local file="$1"

  [[ -f "$file" ]] || die "Missing package file: $file"

  sed -E \
    -e 's/[[:space:]]*#.*$//' \
    -e 's/^[[:space:]]+//' \
    -e 's/[[:space:]]+$//' \
    -e '/^$/d' \
    "$file"
}

require_fedora() {
  [[ -f /etc/os-release ]] || die "Missing /etc/os-release"

  . /etc/os-release
  [[ "${ID:-}" == "fedora" ]] || die "Unsupported OS: ${ID:-unknown}"
}

require_commands() {
  local cmd

  for cmd in "$@"; do
    command -v "$cmd" >/dev/null || die "Required command not found: $cmd"
  done
}

configure_repositories() {
  info "Configuring repositories"

  if ! rpm -q terra-release >/dev/null 2>&1; then
    sudo dnf install -y \
      --nogpgcheck \
      --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
      terra-release
  fi

  if [[ ! -f /etc/yum.repos.d/brave-browser.repo ]]; then
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager addrepo \
      --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
  fi
}

remove_packages() {
  local packages=()

  mapfile -t packages < <(
    while read -r package; do
      rpm -q "$package" >/dev/null 2>&1 && printf '%s\n' "$package"
    done < <(load_packages "$PACKAGE_DIR/dnf-remove.txt")
  )

  (( ${#packages[@]} == 0 )) && return

  info "Removing conflicting packages"
  sudo dnf remove -y "${packages[@]}"
}

install_packages() {
  local packages=()

  mapfile -t packages < <(load_packages "$PACKAGE_DIR/dnf.txt")
  (( ${#packages[@]} > 0 )) || die "No DNF packages configured"

  info "Installing packages"
  sudo dnf install -y "${packages[@]}"
}

install_flatpaks() {
  local apps=()

  command -v flatpak >/dev/null || sudo dnf install -y flatpak

  sudo flatpak remote-add \
    --if-not-exists \
    flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo

  mapfile -t apps < <(load_packages "$PACKAGE_DIR/flatpak.txt")
  (( ${#apps[@]} == 0 )) && return

  info "Installing Flatpak applications"
  sudo flatpak install -y --system flathub "${apps[@]}"
}

install_mise() {
  if [[ ! -x "$MISE_PATH" ]]; then
    info "Installing mise"
    curl -fsSL https://mise.run |
      env MISE_INSTALL_PATH="$MISE_PATH" sh
  fi

  export PATH="${MISE_PATH%/*}:$PATH"

  command -v mise >/dev/null || die "mise is not available"

  info "Installing mise tools"
  mise install
}

main() {
  require_fedora
  require_commands curl dnf rpm sudo systemctl

  sudo -v

  configure_repositories
  remove_packages
  install_packages

  info "Enabling smart card support"
  sudo systemctl enable --now pcscd.socket

  install_flatpaks
  install_mise

  printf '\033[1;32mOK\033[0m Workstation installed\n'
}

main "$@"
