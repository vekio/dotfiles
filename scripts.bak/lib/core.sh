#!/usr/bin/env bash

DOTFILES_SOURCE="${DOTFILES_SOURCE:-$(chezmoi source-path 2>/dev/null || pwd)}"
DOTFILES_NONINTERACTIVE="${DOTFILES_NONINTERACTIVE:-0}"
DOTFILES_YES="${DOTFILES_YES:-0}"
DOTFILES_CURRENT_SCRIPT="${DOTFILES_CURRENT_SCRIPT:-${0}}"

has() {
  command -v "$1" >/dev/null 2>&1
}

is_interactive() {
  [ "$DOTFILES_NONINTERACTIVE" != "1" ] && [ -t 0 ]
}
