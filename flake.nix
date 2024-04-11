{
  description = "PolarizedIons's Machine Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";

    awsvpnclient.url = "github:ymatsiuk/awsvpnclient/main";
    awsvpnclient.inputs.nixpkgs.follows = "nixpkgs";

    getchoo-pkgs.url = "github:getchoo/nix-exprs";
    getchoo-pkgs.inputs.nixpkgs.follows = "nixpkgs";

    teraflops.url = "github:aanderse/teraflops";
    teraflops.inputs.nixpkgs.follows = "nixpkgs";

    # gabmus/envision
    vr-envision.url = "gitlab:Scrumplex/envision/nix";
    vr-envision.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      machines = [ "aegis" "rick" "alyx" "vm" ];
      system = "x86_64-linux";
    in {
      nixosConfigurations = builtins.listToAttrs (builtins.map (machine: {
        name = machine;
        value = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [ ./machines/${machine}/configuration.nix ];
          specialArgs = { inherit inputs system; };
        };
      }) machines);
    };
}
