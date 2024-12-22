{
  imports = [ ./terminal ];

  home = {
    username = "vekio";
    homeDirectory = "/home/vekio";
    stateVersion = "25.05";
  };

  # let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
