{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    # initContent = ''
    #   function rebuild {
    #     sudo nixos-rebuild switch --flake "$@"
    #   }
    # '';
    shellAliases = {
      ll = "ls -l";

    };
  };
}
