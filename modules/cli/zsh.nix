{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    initContent = ''
      # bindkeys
      bindkey '^ ' autosuggest-accept # ctrl + space
      # insensitive tab completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    '';

    # initContent = ''
    #   function rebuild {
    #     sudo nixos-rebuild switch --flake "$@"
    #   }
    # '';

    plugins = [{
      name = "forgit";
      src = pkgs.zsh-forgit;
      file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
    }];

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      ls = "ls --color=auto";
      la = "ls -lA";
      ll = "ls -l";
      l = "ls -A";

      code = "codium";

      reload = ".. && cd -";
    };
  };
}
