{ pkgs, ... }: {
  imports = [ ./git.nix ./zsh.nix ./starship.nix ./fzf.nix ];

  home.packages = with pkgs; [ gnumake ];
}
