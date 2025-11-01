{ pkgs, ... }: {
  imports = [ ./code.nix ./brave.nix ./xdg.nix ./alacritty.nix ./spotify.nix ./gaming.nix ];

  home.packages = with pkgs; [ protonvpn-gui proton-pass vlc wl-clipboard qbittorrent ];
}
