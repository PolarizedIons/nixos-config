{
  description = "PolarizedIons's Machine Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";

    teraflops.url = "github:aanderse/teraflops";
    teraflops.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixpkgs-xr.inputs.nixpkgs.follows = "nixpkgs";

    spplice.url = "github:PolarizedIons/spplice-flake/cpp-beta";
    spplice.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    quickshell.url = "github:outfoxxed/quickshell";
    quickshell.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";
    noctalia.inputs.quickshell.follows = "quickshell";

    steamos-nix.url = "github:Jovian-Experiments/Jovian-NixOS";
    steamos-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      machines = [ "aegis" "rick" "vm" "potatOS" ];
      system = "x86_64-linux";

      # Patch nixpkgs input: https://github.com/NixOS/nixpkgs/pull/142273#issuecomment-948225922
      remoteNixpkgsPatches = [
        # example: 
        # {
        #   meta.description = "#295107: basalt-monado: init at release-673cc5c6";
        #   url =
        #     "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/295107.patch";
        #   hash = "sha256-qKwJKenK6QYYyz27l/xuoUrAzTKobhJRhbxD0z7kWlo=";
        # }
      ];

      localNixpkgsPatches = [ ./patches/envision.diff ];

      originPkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      nixpkgs = originPkgs.applyPatches {
        name = "nixpkgs-patched";
        src = inputs.nixpkgs;
        patches = (map originPkgs.fetchpatch remoteNixpkgsPatches)
          ++ localNixpkgsPatches;
      };

      nixosSystem = import (nixpkgs + "/nixos/lib/eval-config.nix");
      # nixosSystem = inputs.nixpkgs.lib.nixosSystem;
    in {
      nixosConfigurations = builtins.listToAttrs (builtins.map (machine: {
        name = machine;
        value = nixosSystem {
          system = system;
          modules = [
            inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
            ./machines/${machine}/configuration.nix
          ];
          specialArgs = { inherit inputs system; };
        };
      }) machines);
    };
}
