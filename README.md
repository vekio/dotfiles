# dotfiles

## Create docker image

```sh
docker run -d -t --name dotfiles ubuntu:jammy
docker exec -it dotfiles bash

curl -o- -s https://gitea.casta.me/alberto/dotfiles/raw/branch/feature/new-setup/setup.sh | bash -s wsl

apt update && apt install -y curl

docker exec -it dotfiles zsh
```

## Export docker image as distro

```sh
docker export dotfiles > dotfiles.tar
wsl --import dotfiles ./dotfiles dotfiles.tar
```
