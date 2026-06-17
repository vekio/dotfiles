#!/usr/bin/env bash

ensure_dir() {
  local dir="$1"
  local mode="${2:-755}"

  install -d -m "$mode" "$dir"
}

append_line_if_missing() {
  local file="$1"
  local line="$2"

  touch "$file"

  if ! grep -Fxq "$line" "$file"; then
    printf "%s\n" "$line" >> "$file"
  fi
}

write_file() {
  local file="$1"
  local mode="${2:-644}"

  ensure_dir "$(dirname "$file")"
  cat > "$file"
  chmod "$mode" "$file"
}
