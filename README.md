# dotfiles

Personal dotfiles configuration using Nix, Flakes and Home-Manager.

## Installation

Installation steps:

1. Installing Nix using [Determinate Nix installer](https://zero-to-nix.com/concepts/nix-installer): `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`
2. Select the profile you want to apply its settings to: `nix run home-manager -- switch --flake .#PROFILE`
3. Activate Zsh shell: `sudo chsh -s "$(which zsh)" "${USER}"`

After installation to change the profile you need to run: `home-manager switch --flake .#PROFILE`

## 💭 Inspired By

- [sioodmy/dotfiles](https://github.com/sioodmy/dotfiles)
- [hlissner/dotfiles](https://github.com/hlissner/dotfiles)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
- [viperML/dotfiles](https://github.com/viperML/dotfiles)
- [colemickens/nixcfg](https://github.com/colemickens/nixcfg)
- [Mic92/dotfiles](https://github.com/Mic92/dotfiles)
- [LongerHV/nixos-configuration](https://github.com/LongerHV/nixos-configuration)

## 💾 Resources

- [Home Manager Options](https://nix-community.github.io/home-manager/options.xhtml)
- [Effortless dev environments with Nix and direnv](https://determinate.systems/posts/nix-direnv/)
- [Zero to Nix](https://zero-to-nix.com/)
- [vimjoyer](https://www.youtube.com/@vimjoyer/videos)

## ⚙️ Configs

### Windows Terminal

- Theme: Gruvbox Dark (from gruvbox_dark.json file)
- Font: Cascadia Mono PL
