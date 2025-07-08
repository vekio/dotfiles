{ pkgs, ... }: {
  home.packages = with pkgs; [
    # archives

    # misc

    # overview
    neofetch
    htop

    # file system
    tree

    # web utils
    curl
    wget

    # cryptography
    gnupg

    # develop
    nixfmt-classic
    gnumake
    entr

    # asciidoc
    asciidoctor

    # charm
    gum

    # TODO
    # zip
    # unzip
    # du-dust
    # duf
    # fd
    # file
    # jaq
    # ripgrep
  ];
}
