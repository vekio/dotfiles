#!/usr/bin/env bash

# Read package/app lists that may contain blank lines and comments.
read_package_file() {
  local file="$1"

  [ -f "$file" ] || fail "Missing package file: $file"

  grep -Ev '^\s*(#|$)' "$file" | sed 's/#.*//' | awk '{$1=$1};1'
}
