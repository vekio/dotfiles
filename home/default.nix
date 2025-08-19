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
    proton-pass

    gnumake
  ];

  # TODO sway
  # wayland.windowManager.sway = {
  #   enable = true;
  #   config = {
  #     modifier = "Mod4";
  #     terminal = "alacritty";
  #     # menu = "wofi --show drun";
  #     startup = [{ command = "brave"; }];
  #   };
  # };

  # services.mako.enable = true;
}
