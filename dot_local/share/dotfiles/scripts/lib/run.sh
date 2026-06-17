#!/usr/bin/env bash

# Run external commands with dimmed output so script milestones stay readable.
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
  local previous_script="${DOTFILES_CURRENT_SCRIPT:-}"
  local command
  local status

  [ -f "$script" ] || fail "Missing script: $script"

  command="$(command_string bash "$script")"
  printf "\033[2m+ %s\033[0m\n" "$command"

  set +e
  DOTFILES_CURRENT_SCRIPT="$script" bash "$script"
  status=$?
  set -e

  DOTFILES_CURRENT_SCRIPT="$previous_script"

  if [ "$status" -ne 0 ]; then
    fail "Script failed: $script (exit $status). Resume with: $script"
  fi
}
