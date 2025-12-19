{ pkgs, ... }: {
  home.packages = with pkgs; [
    prismlauncher
    lutris
    wineWowPackages.staging
    winetricks
    protonup-qt
    mangohud
    gamescope
  ];
}
