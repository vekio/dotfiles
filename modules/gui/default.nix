{ pkgs, ... }: {
  imports = [ ./code.nix ./brave.nix ./xdg.nix ./kitty.nix ];

  home.packages = with pkgs; [ protonvpn-gui proton-pass vlc ];
}
