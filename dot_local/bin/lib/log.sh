#!/usr/bin/env sh

# Simple logging helpers for shell scripts.

log__use_color() {
  [ -t 2 ] && [ -z "${NO_COLOR:-}" ]
}

log__color() {
  # $1 = color code, $2 = message
  if log__use_color; then
    printf '\033[%sm%s\033[0m' "$1" "$2"
  else
    printf '%s' "$2"
  fi
}

log__emit() {
  # $1 = level, $2 = color code, $3... = message
  level="$1"
  color="$2"
  shift 2
  label="$(log__color "$color" "[$level]")"
  printf '%s %s\n' "$label" "$*" >&2
}

log_info() { log__emit INFO 34 "$@"; }
log_warn() { log__emit WARN 33 "$@"; }
log_error() { log__emit ERROR 31 "$@"; }
log_debug() {
  [ "${LOG_LEVEL:-}" = "debug" ] && log__emit DEBUG 90 "$@"
}
