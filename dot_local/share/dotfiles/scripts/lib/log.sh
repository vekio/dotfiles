#!/usr/bin/env bash

# Print a major step header.
title() {
  printf "\n\033[1;34m== %s ==\033[0m\n" "$*"
}

# Print an informational message.
info() {
  printf "\033[1;34m==>\033[0m %s\n" "$*"
}

# Print low-priority progress detail.
detail() {
  printf "\033[2m│ %s\033[0m\n" "$*"
}

# Print a successful step message.
success() {
  printf "\033[1;32mOK\033[0m  %s\n" "$*"
}

# Print a warning to stderr.
warn() {
  printf "\033[1;33mWARN\033[0m  %s\n" "$*" >&2
}

# Print an error to stderr and stop.
fail() {
  printf "\033[1;31mERROR\033[0m  %s\n" "$*" >&2
  exit 1
}
