{ config, pkgs, ... }:

{
  home.username = "alberto";
  home.homeDirectory = "/home/alberto";
  programs.zsh.enable = true;
  home.packages = with pkgs; [
    htop
    git
    vim
  ];
  home.stateVersion = "25.05";
}

