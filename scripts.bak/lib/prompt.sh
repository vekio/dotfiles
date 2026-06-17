#!/usr/bin/env bash

confirm() {
  local question="$1"
  local default="${2:-no}"

  if [ "$DOTFILES_YES" = "1" ]; then
    return 0
  fi

  if ! is_interactive; then
    [ "$default" = "yes" ]
    return $?
  fi

  if has gum; then
    if [ "$default" = "yes" ]; then
      gum confirm --default=true "$question"
    else
      gum confirm "$question"
    fi
  else
    local answer
    read -r -p "$question [y/N]: " answer
    case "$answer" in
      y|Y|yes|YES) return 0 ;;
      *) return 1 ;;
    esac
  fi
}

prompt_input() {
  local prompt="$1"
  local default="${2:-}"

  if ! is_interactive; then
    printf "%s" "$default"
    return
  fi

  if has gum; then
    gum input --prompt "$prompt " --value "$default"
  else
    local answer
    read -r -p "$prompt " answer
    printf "%s" "${answer:-$default}"
  fi
}
