{ config, pkgs, ... }:

{
  home.username = "vekio";
  home.homeDirectory = "/home/vekio";
  
  programs.zsh = {
    enable = true;
    initContent = ''
      function rebuild {
        sudo nixos-rebuild switch --flake "$@"
      }
    '';
    shellAliases = {
      ll = "ls -l";
    };
  };
  
  home.packages = with pkgs; [
    htop
    git
    gitflow
    vim
    vscodium

    # gui
    brave
    protonvpn-gui
  ];

  home.stateVersion = "25.05";

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userSettings = {
      "editor.formatOnSave" = true;
    };
  };

  # programs.chromium = {
  #   enable = true;
  #   package = pkgs.brave;
  #   extensions = [
  #     { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark-reader
  #     { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # proton-pass
  #     { id = "jplgfhpmjnbigmhklmmbgecoobifkmpa"; } # proton-vpn
  #   ];
  #   # commandLineArgs = [    ];
  # };

  programs.git = {
    enable = true;
    userName = "Alberto Castañeiras";
    userEmail = "alberto@casta.me";
    extraConfig = {
      init.defaultBranch = "main";
      gitflow.branch.master = "main";
      gitflow.branch.develop = "develop";
      gitflow.prefix.feature = "feature/";
      gitflow.prefix.release = "release/";
      gitflow.prefix.hotfix = "hotfix/";
      gitflow.prefix.support = "support/";
      gitflow.prefix.versiontag = "v";
    };
  };
}

