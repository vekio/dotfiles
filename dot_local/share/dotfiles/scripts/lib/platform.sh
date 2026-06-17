#!/usr/bin/env bash

# Read the OS identifier from /etc/os-release.
os_id() {
  [ -f /etc/os-release ] || fail "Missing /etc/os-release"
  . /etc/os-release
  echo "${ID:-unknown}"
}

# Stop unless the current OS is Fedora.
require_fedora() {
  local os
  os="$(os_id)"

  [ "$os" = "fedora" ] || fail "Unsupported OS: $os"
}
