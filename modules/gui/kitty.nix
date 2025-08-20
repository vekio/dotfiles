{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
    themeFile = "Catppuccin-Mocha";
    font = {
      name = "FiraCode Nerd Font";
      size = 11;
    };
  };
}
