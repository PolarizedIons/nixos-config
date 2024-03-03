{
  description = "PolarizedIons's Machine Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      machines = [ "aegis" "rick" "vm" ];
      system = "x86_64-linux";
      unstable = import inputs.unstable {
        system = system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = builtins.listToAttrs (builtins.map (machine: {
        name = machine;
        value = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [ ./machines/${machine}/configuration.nix ];
          specialArgs = { inherit unstable inputs; };
        };
      }) machines);
    };
}
