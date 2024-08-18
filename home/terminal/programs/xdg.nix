{ config, ... }: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "$HOME/documents";
      download = "$HOME/downloads";
      videos = "$HOME/videos";
      music = "$HOME/music";
      pictures = "$HOME/pictures";
      desktop = "$HOME/other";
      publicShare = "$HOME/other";
      templates = "$HOME/other";
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/screenshots";
      };
    };
  };
}
