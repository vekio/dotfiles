#!/usr/bin/env bash

set -Eeuo pipefail

readonly PACKAGES_DIR="$HOME/.local/share/dotfiles/packages/fedora"

info() {
  printf '\033[1;34m==>\033[0m %s\n' "$*"
}

die() {
  printf '\033[1;31mERROR\033[0m %s\n' "$*" >&2
  exit 1
}

read_package_file() {
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
  [[ -r /etc/os-release ]] || die "Missing /etc/os-release"

  # shellcheck disable=SC1091
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
    # terra-release installs the key used to verify every later Terra package.
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

remove_dnf_packages() {
  local packages=()

  mapfile -t packages < <(
    while read -r package; do
      rpm -q "$package" >/dev/null 2>&1 && printf '%s\n' "$package"
    done < <(read_package_file "$PACKAGES_DIR/dnf-remove.txt")
  )

  (( ${#packages[@]} == 0 )) && return

  info "Removing conflicting packages"
  sudo dnf remove -y "${packages[@]}"
}

install_dnf_packages() {
  local packages=()

  mapfile -t packages < <(read_package_file "$PACKAGES_DIR/dnf.txt")
  (( ${#packages[@]} > 0 )) || die "No DNF packages configured"

  info "Installing packages"
  sudo dnf install -y "${packages[@]}"
}

install_flatpak_apps() {
  local apps=()

  command -v flatpak >/dev/null || sudo dnf install -y flatpak

  sudo flatpak remote-add \
    --if-not-exists \
    flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo

  mapfile -t apps < <(read_package_file "$PACKAGES_DIR/flatpak.txt")
  (( ${#apps[@]} == 0 )) && return

  info "Installing Flatpak applications"
  sudo flatpak install -y --system flathub "${apps[@]}"
}

install_mise() {
  local installer
  local mise_path="$HOME/.local/bin/mise"

  if [[ ! -x "$mise_path" ]]; then
    info "Installing mise"
    installer="$(mktemp)"
    curl -fsSL https://mise.run -o "$installer"
    env MISE_INSTALL_PATH="$mise_path" sh "$installer"
    rm -f "$installer"
  fi

  [[ -x "$mise_path" ]] || die "mise is not available"

  info "Installing mise tools"
  "$mise_path" install
}

main() {
  require_fedora
  require_commands curl dnf rpm sudo systemctl

  sudo -v

  configure_repositories
  remove_dnf_packages
  install_dnf_packages

  info "Enabling smart card support"
  sudo systemctl enable --now pcscd.socket

  install_flatpak_apps
  install_mise

  printf '\033[1;32mOK\033[0m Workstation installed\n'
}

main "$@"
