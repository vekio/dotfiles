{ config, pkgs, ... }:

{
  imports = [ ../modules/gui ../modules/cli ];

  home = {
    username = "alberto";
    homeDirectory = "/home/alberto";
    stateVersion = "26.05";
  };

  home.packages = with pkgs; [ nixfmt gnumake ];

  home.file = { "${config.home.homeDirectory}/.local/bin/.keep".text = ""; };

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/.local/share/go";
    GOBIN = "${config.home.homeDirectory}/.local/share/go/bin";
    VISUAL = "codium";
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
