{
  imports = [
    ./git.nix
    ./zsh.nix
    ./starship.nix
    ./fzf.nix
    ./direnv.nix
    ./tmux.nix
    ./packages.nix
  ];

  home.packages = with pkgs; [ gum ];
}
