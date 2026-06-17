#!/usr/bin/env bash

title() {
  printf "\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n" "$*"
}

info() {
  printf "\033[1;34m==>\033[0m %s\n" "$*"
}

success() {
  printf "\033[1;32mOK\033[0m  %s\n" "$*"
}

warn() {
  printf "\033[1;33mWARN\033[0m  %s\n" "$*" >&2
}

fail() {
  printf "\033[1;31mERROR\033[0m  %s\n" "$*" >&2
  exit 1
}
