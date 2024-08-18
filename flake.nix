{
  description = "vekio's dotfiles with home-manager and flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [ ./home/profiles ];
      perSystem = { inputs, config, pkgs, ... }: {
        formatter = pkgs.nixfmt-classic;
        devShells.default = pkgs.mkShell {
          name = "dotfiles";
          packages = with pkgs;
            [
              # git
              # TODO
              # nil # nix ls
              # glow # markdown viewer
              # statix # lints and suggestions
              # deadnix # clean up unused nix code
            ];
        };
      };
    };
}
