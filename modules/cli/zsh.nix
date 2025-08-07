{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    # initContent = ''
    #   function rebuild {
    #     sudo nixos-rebuild switch --flake "$@"
    #   }
    # '';
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      ls = "ls --color=auto";
      la = "ls -lA";
      ll = "ls -l";
      l = "ls -A";

      reload = ".. && cd -";
    };
  };
}
