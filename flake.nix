{
  description = "PolarizedIons's Machine Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, unstable, ... }@inputs:
    let
      machines = [ "aegis" "rick" "vm" ];
      system = "x86_64-linux";
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
