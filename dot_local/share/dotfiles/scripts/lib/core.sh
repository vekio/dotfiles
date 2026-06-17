#!/usr/bin/env bash

DOTFILES_CURRENT_SCRIPT="${DOTFILES_CURRENT_SCRIPT:-${0}}"

# Return true when a command is available in PATH.
has() {
  command -v "$1" >/dev/null 2>&1
}

# Format a command for readable logs.
command_string() {
  printf "%q " "$@"
}
