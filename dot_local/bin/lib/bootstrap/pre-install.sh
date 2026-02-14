#!/usr/bin/env bash
set -euo pipefail

source "$DOTLIB/log.sh"

if ! command -v dnf >/dev/null 2>&1; then
  log_warn "dnf not found; skipping"
  exit 0
fi

log_info "enabling COPR repos"
sudo dnf -y copr enable jdxcode/mise
sudo dnf -y copr enable atim/starship

REPO_FILE="/etc/yum.repos.d/vscodium.repo"
if [ ! -f "$REPO_FILE" ]; then
  log_info "installing vscodium repo file: $REPO_FILE"
  sudo tee "$REPO_FILE" >/dev/null <<'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=gitlab.com_paulcarroty_vscodium_repo
baseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF
else
  log_debug "vscodium repo file already present: $REPO_FILE"
fi
