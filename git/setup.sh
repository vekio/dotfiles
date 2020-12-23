#!/usr/bin/env bash
set -eo pipefail

SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Install git
sudo apt install git

# Global config
git config --global user.name "Alberto Castañeiras"
git config --global user.email "alberto@casta.me"
git config --global github.user "vekio"
git config --global color.ui true

