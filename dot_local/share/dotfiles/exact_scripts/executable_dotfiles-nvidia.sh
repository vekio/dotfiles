#!/usr/bin/env bash

set -Eeuo pipefail

FORCE=0

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

warn() {
  printf 'WARN: %s\n' "$*" >&2
}

has() {
  command -v "$1" >/dev/null 2>&1
}

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    -h|--help)
      printf 'Usage: %s [--force]\n' "$0"
      exit 0
      ;;
    *) fail "Unknown argument: $arg" ;;
  esac
done

[ -f /etc/os-release ] || fail "Missing /etc/os-release"
# shellcheck disable=SC1091
source /etc/os-release
[ "${ID:-}" = "fedora" ] || fail "Unsupported OS: ${ID:-unknown}"

if ! rpm -q rpmfusion-free-release rpmfusion-nonfree-release >/dev/null 2>&1; then
  fedora_version="$(rpm -E %fedora)"
  printf 'Configuring RPM Fusion for Fedora %s\n' "$fedora_version"
  sudo dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_version}.noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_version}.noarch.rpm"
fi

if has lspci; then
  if ! lspci | grep -Ei 'nvidia|3d controller|vga compatible controller' | grep -qi nvidia; then
    if [ "$FORCE" = "1" ]; then
      warn "No NVIDIA GPU detected; continuing because --force was set"
    else
      fail "No NVIDIA GPU detected. Use --force to override."
    fi
  fi
else
  warn "lspci is not available; skipping GPU detection"
fi

if has mokutil && mokutil --sb-state 2>/dev/null | grep -qi enabled; then
  if [ "$FORCE" = "1" ]; then
    warn "Secure Boot appears enabled; continuing because --force was set"
  else
    fail "Secure Boot appears enabled. Handle module signing or use --force."
  fi
fi

printf 'Installing NVIDIA packages\n'
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda nvidia-settings

if [ ! -f /etc/yum.repos.d/nvidia-container-toolkit.repo ]; then
  repo_file="$(mktemp)"
  curl -fsSL \
    https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo \
    -o "$repo_file"
  sudo install -m 0644 "$repo_file" /etc/yum.repos.d/nvidia-container-toolkit.repo
  rm -f "$repo_file"
fi

sudo dnf install -y nvidia-container-toolkit
sudo akmods --force
sudo dracut --force
sudo systemctl enable --now nvidia-cdi-refresh.path
sudo systemctl enable --now nvidia-cdi-refresh.service

printf 'NVIDIA driver installed. Reboot, then run: nvidia-smi\n'
