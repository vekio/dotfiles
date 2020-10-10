#!/bin/bash
#
# Remove originals files and make symlinks

set -a; . .env; set +a

# bashrc
rm ~/.bashrc
ln -s ~/dotfiles/.bashrc ~/.bashrc

# vimrc
ln -s ~/dotfiles/.vimrc ~/.vimrc

# aliases
ln -s ~/dotfiles/.aliases ~/.aliases

# profile
rm ~/.profile
ln -s ~/dotfiles/.profile ~/.profile

# gitconfig
ln -s ~/dotfiles/.gitconfig ~/.gitconfig

# gitconfig.user
cp ~/dotfiles/.gitconfig.user ~/.gitconfig.user
sed -i "s/GITUSER/$GITUSER/g" ~/.gitconfig.user
sed -i "s/GITEMAIL/$GITEMAIL/g" ~/.gitconfig.user