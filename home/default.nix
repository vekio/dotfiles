{ config, pkgs, ... }:

{
  home.username = "vekio";
  home.homeDirectory = "/home/vekio";
  
  programs.zsh = {
    enable = true;
    initContent = ''
      function rebuild {
        sudo nixos-rebuild switch --flake "$@"
      }
    '';
    shellAliases = {
      ll = "ls -l";
    };
  };
  
  home.packages = with pkgs; [
    htop
    git
    vim
    vscodium
  ];

  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    userName = "Alberto";
    userEmail = "alberto@casta.me";
  };
}

