#!/usr/bin/env bash

# Read package/app lists that may contain blank lines and comments.
read_package_file() {
  local file="$1"

  [ -f "$file" ] || fail "Missing package file: $file"

  grep -Ev '^\s*(#|$)' "$file" | sed 's/#.*//' | awk '{$1=$1};1'
}

# Install all packages listed in a package file with dnf.
dnf_install_packages_from_file() {
  local file="$1"
  local packages=()

  mapfile -t packages < <(read_package_file "$file")

  if [ "${#packages[@]}" -eq 0 ]; then
    warn "No packages in $file"
    return
  fi

  run sudo dnf install -y "${packages[@]}"
}
