{ config, ... }:
let
  data = config.xdg.dataHome;
  conf = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in {
  imports = [ ./programs ./shell/starship.nix ./shell/zsh.nix ];
  # environment variables
  home.sessionVariables = {
    # TODO
    # clean up ~
    # LESSHISTFILE = "${cache}/less/history";
    # LESSKEY = "${conf}/less/lesskey";
    EDITOR = "nvim";
  };
  # directories to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];
}
