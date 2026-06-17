#!/usr/bin/env bash

command_string() {
  printf "%q " "$@"
}

run() {
  local status
  local command

  command="$(command_string "$@")"
  printf "+ %s\n" "$command"

  if "$@"; then
    return 0
  else
    status=$?
  fi

  fail "Command failed (exit $status): $command"
}

run_script() {
  local script="$1"
  local previous_script="${DOTFILES_CURRENT_SCRIPT:-}"
  local status

  [ -f "$script" ] || fail "Missing script: $script"

  title "Running $script"

  set +e
  DOTFILES_CURRENT_SCRIPT="$script" bash "$script"
  status=$?
  set -e

  DOTFILES_CURRENT_SCRIPT="$previous_script"

  if [ "$status" -ne 0 ]; then
    fail "Script failed: $script (exit $status). Resume with: $script"
  fi
}
