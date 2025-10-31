{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    theme = "catppuccin_mocha";
    settings = {
      # env = { TERM = "screen-256color"; };
      general = { live_config_reload = true; };
      terminal.shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [ "new-session" "-A" "-s" "main" ];
      };
      window = {
        dynamic_padding = true;
        decorations = "full";
      };
      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        size = 11.0;
      };
      scrolling.history = 100000;
    };
  };
}
