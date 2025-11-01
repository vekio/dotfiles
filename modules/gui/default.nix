{ pkgs, ... }: {
  imports = [ ./code.nix ./brave.nix ./xdg.nix ./alacritty.nix ./spotify.nix ];

  home.packages = with pkgs; [ protonvpn-gui proton-pass vlc wl-clipboard ];
}
