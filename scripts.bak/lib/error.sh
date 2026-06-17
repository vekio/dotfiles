#!/usr/bin/env bash

on_error() {
  local exit_code="$1"
  local line="$2"
  local command="$3"
  local script="${DOTFILES_CURRENT_SCRIPT:-${0}}"

  printf "\n" >&2
  if has gum; then
    gum style --foreground 196 --bold "ERROR  Failed at $script:$line (exit $exit_code): $command" >&2
  else
    printf "ERROR  Failed at %s:%s (exit %s): %s\n" "$script" "$line" "$exit_code" "$command" >&2
  fi
  exit "$exit_code"
}

trap 'on_error "$?" "$LINENO" "$BASH_COMMAND"' ERR
