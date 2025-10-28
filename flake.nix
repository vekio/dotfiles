{
  description = "vekio's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix4vscode, ... }:
    let
      system = "x86_64-linux";
      username = "alberto";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nix4vscode.overlays.default ];
        config = { allowUnfree = true; };
      };
    in {
      nixosConfigurations = {
        # host titan
        titan = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./hosts/titan/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./home/default.nix;
              };
            }
          ];
        };
      };
    };
}
