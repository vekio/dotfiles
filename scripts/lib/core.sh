#!/usr/bin/env bash

DOTFILES_CURRENT_SCRIPT="${DOTFILES_CURRENT_SCRIPT:-${0}}"

command_string() {
  printf "%q " "$@"
}
