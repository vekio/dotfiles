#!/usr/bin/env bash

read_package_file() {
  local file="$1"

  [ -f "$file" ] || fail "Missing package file: $file"

  grep -Ev '^\s*(#|$)' "$file" | sed 's/#.*//' | awk '{$1=$1};1'
}

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

dnf_install_if_available() {
  local available=()
  local pkg

  for pkg in "$@"; do
    if dnf -q info "$pkg" >/dev/null 2>&1; then
      available+=("$pkg")
    else
      warn "Package not available in current repos: $pkg"
    fi
  done

  if [ "${#available[@]}" -gt 0 ]; then
    run sudo dnf install -y "${available[@]}"
  fi
}
