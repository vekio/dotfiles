# dotfiles

```txt
Usage: SYNOPSIS
  dotfiles.sh [OPTIONS] COMMAND

DESCRIPTION
  Installs and config different setups
  If no command is given, install default setup

COMMANDS
  default             install default setup
  wsl                 install wsl setup
  sdk                 install sdk setup
  devops              install devops setup

OPTIONS
  -v, --version       display version information and exit
  -h, --help          display this help text and exit

IMPLEMENTATION
  version             setup.sh alpha
  author              Alberto Castañeiras
```

## Install

```sh
git clone https://github.com/vekio/dotfiles.git
cd dotfiles && ./dotfiles.sh wsl
chsh -s "$(command -v zsh)" && exec zsh -l
```

## WSL distro

Create a WSL distro with personal dotfiles in it.

```sh
docker run -d -t --name dotfiles ubuntu:jammy
docker exec -it dotfiles bash

# execute inside the container
> apt update && apt install -y curl
> git clone https://github.com/vekio/dotfiles.git
> cd dotfiles && ./dotfiles.sh wsl
> chsh -s "$(command -v zsh)" && exec zsh -l
# exit from the container

docker export dotfiles > dotfiles.tar
wsl --import dotfiles ./dotfiles dotfiles.tar
```

## Development

Tests with docker image.

```sh
# Test dotfiles in ubuntu image as a sudo user
make test-user

# Test dotfiles in ubuntu image as root
make test-root
```
