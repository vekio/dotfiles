#!/usr/bin/env bash

title() {
  if has gum; then
    gum style \
      --border normal \
      --padding "0 1" \
      --margin "1 0" \
      --bold \
      "$*"
  else
    printf "\n== %s ==\n" "$*"
  fi
}

info() {
  if has gum; then
    gum style --foreground 39 "==> $*"
  else
    printf "\n==> %s\n" "$*"
  fi
}

success() {
  if has gum; then
    gum style --foreground 46 "OK  $*"
  else
    printf "OK  %s\n" "$*"
  fi
}

warn() {
  if has gum; then
    gum style --foreground 214 "WARN  $*" >&2
  else
    printf "WARN  %s\n" "$*" >&2
  fi
}

fail() {
  if has gum; then
    gum style --foreground 196 --bold "ERROR  $*" >&2
  else
    printf "ERROR  %s\n" "$*" >&2
  fi
  exit 1
}
