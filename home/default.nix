{
  imports = [ ./terminal ];

  home = {
    username = "vekio";
    homeDirectory = "/home/vekio";
    stateVersion = "24.05";
  };

  # let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
