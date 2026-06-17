#!/usr/bin/env bash

on_error() {
  local exit_code="$1"
  local line="$2"
  local command="$3"
  local script="${DOTFILES_CURRENT_SCRIPT:-${0}}"

  printf "\n\033[1;31mERROR\033[0m  Failed at %s:%s (exit %s): %s\n" \
    "$script" "$line" "$exit_code" "$command" >&2
  exit "$exit_code"
}

trap 'on_error "$?" "$LINENO" "$BASH_COMMAND"' ERR
