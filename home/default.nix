{ config, pkgs, ... }:

{
  imports = [ ../modules/gui ../modules/cli ];

  home = {
    username = "alberto";
    homeDirectory = "/home/alberto";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [ nixfmt-classic gnumake ];

  home.file = { };

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/.local/share/go";
    GOBIN = "${config.home.homeDirectory}/.local/share/go/bin";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
