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
    vlc
    gnumake
  ];

  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      # Cambiar entre workspaces con Ctrl+Super+flechas
      "switch-to-workspace-left" = [ "<Primary><Super>Left" ];
      "switch-to-workspace-right" = [ "<Primary><Super>Right" ];
      "switch-to-workspace-up" = [ "<Primary><Super>Up" ];
      "switch-to-workspace-down" = [ "<Primary><Super>Down" ];

      # Mover la ventana con Ctrl+Super+Shift+flechas
      "move-to-workspace-left" = [ "<Primary><Super><Shift>Left" ];
      "move-to-workspace-right" = [ "<Primary><Super><Shift>Right" ];
      "move-to-workspace-up" = [ "<Primary><Super><Shift>Up" ];
      "move-to-workspace-down" = [ "<Primary><Super><Shift>Down" ];
    };
  };

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
