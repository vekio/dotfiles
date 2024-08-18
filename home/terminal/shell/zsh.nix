{ config, ... }: {
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      zsh
      exit
    '';
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    dirHashes = {
      dl = "$HOME/downloads"; # cd ~dl
      docs = "$HOME/documents";
      pics = "$HOME/pictures";
      vids = "$HOME/videos";
      src = "$HOME/source";
    };
    # dotDir = "${config.xdg.configHome}/zsh";

    # history = {
    #   expireDuplicatesFirst = true;
    #   path = "${config.xdg.dataHome}/zsh_history";
    #   extended = true;
    # };

    # https://github.com/fufexan/dotfiles/blob/main/home/terminal/shell/zsh.nix
    initExtra = ''
      # bindkeys
      bindkey '^ ' autosuggest-accept # ctrl + space
      # insensitive tab completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '';

    # aliases
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      ls = "ls --color=auto";
      la = "ls -A";
      ll = "ls -lF";
      l = "ls -CF";

      # dev = "nix develop --command zsh";

      # grep = "grep --color";
      # ip = "ip --color";
      # l = "eza -l";
      # la = "eza -la";
      # md = "mkdir -p";
      # ppc = "powerprofilesctl";
      # pf = "powerprofilesctl launch -p performance";
      # us = "systemctl --user";
      # rs = "sudo systemctl";
    };
  };
}
