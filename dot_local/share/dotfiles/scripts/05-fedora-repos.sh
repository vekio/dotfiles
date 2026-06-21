#!/usr/bin/env bash
#
# Configure the third-party Fedora repositories required by the package lists.
# The script is safe to re-run: each repository is checked before installation.

set -Eeuo pipefail

SCRIPTS="${DOTFILES_SCRIPTS:-$HOME/.local/share/dotfiles/scripts}"
source "$SCRIPTS/lib.sh"

require_fedora

FEDORA_VERSION="$(rpm -E %fedora)"

title "Fedora repositories"

enable_rpmfusion() {
  if rpm -q rpmfusion-free-release >/dev/null 2>&1 && \
     rpm -q rpmfusion-nonfree-release >/dev/null 2>&1; then
    detail "RPM Fusion already configured"
    return
  fi

  detail "Configuring RPM Fusion for Fedora $FEDORA_VERSION"
  run sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"
}

enable_terra() {
  if rpm -q terra-release >/dev/null 2>&1; then
    detail "Terra already configured"
    return
  fi

  detail "Configuring Terra"
  run sudo dnf install -y \
    --nogpgcheck \
    --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
    terra-release
}

enable_brave() {
  if [ -f /etc/yum.repos.d/brave-browser.repo ]; then
    detail "Brave repository already configured"
    return
  fi

  detail "Installing dnf config-manager support"
  run sudo dnf install -y dnf-plugins-core

  detail "Configuring Brave repository"
  run sudo dnf config-manager addrepo \
    --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
}

enable_starship() {
  local repo_file="/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:atim:starship.repo"

  if [ -f "$repo_file" ]; then
    detail "Starship COPR already configured"
    return
  fi

  detail "Installing dnf copr support"
  run sudo dnf install -y dnf-plugins-core

  detail "Configuring Starship COPR"
  run sudo dnf copr enable -y atim/starship
}

enable_rpmfusion
enable_terra
enable_brave
enable_starship

success "Fedora repositories configured"
