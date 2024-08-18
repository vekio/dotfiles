{ self, inputs, ... }:
let

  extraSpecialArgs = { inherit inputs self; };

  homeImports = { wsl = [ ../. ./wsl ]; };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {

  _module.args = { inherit homeImports; };

  flake = {
    homeConfigurations = {
      wsl = homeManagerConfiguration {
        modules = homeImports.wsl;
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
