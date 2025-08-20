{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "FiraCode Nerd Font";
      size = 11;
    };
  };
}
