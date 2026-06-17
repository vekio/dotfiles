#!/usr/bin/env bash

os_id() {
  [ -f /etc/os-release ] || fail "Missing /etc/os-release"
  . /etc/os-release
  echo "${ID:-unknown}"
}

require_fedora() {
  local os
  os="$(os_id)"
  [ "$os" = "fedora" ] || fail "Unsupported OS: $os"
}
