{ config, ... }: {
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      time = { disabled = true; };
      docker_context = {
        format = "via [🐳 $context](blue bold) ";
        only_with_files = false;
      };
    };
  };
}
