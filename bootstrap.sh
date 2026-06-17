#!/usr/bin/env bash
#
# Bootstrap a new workstation enough to hand off to chezmoi:
# install the base tools, initialize this dotfiles repo, then run the installer.
# Keep this script self-contained because it may run before the repo exists.

set -Eeuo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://git.casta.me/alberto/dotfiles_new.git}"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-main}"

export PATH="$HOME/.local/bin:$PATH"

has() {
  command -v "$1" >/dev/null 2>&1
}

title() {
  printf "\033[1;34m== %s ==\033[0m\n" "$*"
}

info() {
  printf "\033[1;34m==>\033[0m %s\n" "$*"
}

success() {
  printf "\033[1;32mOK\033[0m  %s\n" "$*"
}

fail() {
  printf "\033[1;31mERROR\033[0m  %s\n" "$*" >&2
  exit 1
}

command_string() {
  printf "%q " "$@"
}

# Run external commands with dimmed output so bootstrap milestones stay readable.
run() {
  local command
  local status

  command="$(command_string "$@")"
  printf "\033[2m+ %s\033[0m\n" "$command"

  if "$@" \
      > >(sed 's/^/\x1b[2m│ /; s/$/\x1b[0m/') \
      2> >(sed 's/^/\x1b[2m│ /; s/$/\x1b[0m/' >&2); then
    return 0
  else
    status=$?
  fi

  fail "Command failed (exit $status): $command"
}

# Run our own scripts without dimming their output; they already format logs.
run_script() {
  local script="$1"
  local command
  local status

  [ -f "$script" ] || fail "Missing script: $script"

  command="$(command_string bash "$script")"
  printf "\033[2m+ %s\033[0m\n" "$command"

  set +e
  bash "$script"
  status=$?
  set -e

  if [ "$status" -ne 0 ]; then
    fail "Script failed: $script (exit $status)"
  fi
}

detect_os() {
  [ -f /etc/os-release ] || fail "Missing /etc/os-release"
  . /etc/os-release
  echo "${ID:-unknown}"
}

install_base_fedora() {
  title "Installing base tools"

  has sudo || fail "sudo is not installed"
  has dnf || fail "dnf is not installed"

  run sudo dnf install -y \
    ca-certificates \
    curl \
    git \
    openssh-clients \
    chezmoi
}

install_base_tools() {
  local os
  os="$(detect_os)"

  case "$os" in
    fedora)
      install_base_fedora
      ;;
    *)
      fail "Unsupported OS: $os"
      ;;
  esac
}

main() {
  install_base_tools

  if chezmoi source-path >/dev/null 2>&1; then
    info "Chezmoi already initialized: $(chezmoi source-path)"
  else
    title "Initializing dotfiles"
    info "Repository: $DOTFILES_REPO"
    run chezmoi init --branch "$DOTFILES_BRANCH" "$DOTFILES_REPO"
  fi

  run_script "$(chezmoi source-path)/dot_local/bin/executable_dotfiles-install"

  success "Bootstrap complete"
}

main "$@"
