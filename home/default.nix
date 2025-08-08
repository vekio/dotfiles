{ config, pkgs, ... }:

{

  imports = [ ../modules/gui ../modules/cli ];

  home = {
    username = "vekio";
    homeDirectory = "/home/vekio";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    vim
    htop
    nixfmt-classic
    neofetch
    # gui
    protonvpn-gui
  ];
}
