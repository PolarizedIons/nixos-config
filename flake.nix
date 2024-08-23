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

    pam-beacon-rs.url = "github:PolarizedIons/pam-beacon-rs";
    pam-beacon-rs.inputs.nixpkgs.follows = "nixpkgs";

    sddm-catppuccin.url = "github:khaneliman/catppuccin-sddm-corners";
    sddm-catppuccin.inputs.nixpkgs.follows = "nixpkgs";

    nix-inspect.url = "github:bluskript/nix-inspect";
    nix-inspect.inputs.nixpkgs.follows = "nixpkgs";

    # intentionally not following nixpkgs
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    hyprsplit.url = "github:shezdy/hyprsplit";
    hyprsplit.inputs.hyprland.follows = "hyprland";

    nix-colors.url = "github:misterio77/nix-colors";

    aws-vpn-client.url = "github:Polarizedions/aws-vpn-client-flake";
    aws-vpn-client.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixpkgs-xr.inputs.nixpkgs.follows = "nixpkgs";

    spplice.url = "github:PolarizedIons/spplice-flake/cpp-beta";
    spplice.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      machines = [ "aegis" "rick" "alyx" "vm" ];
      system = "x86_64-linux";

      # Patch nixpkgs input: https://github.com/NixOS/nixpkgs/pull/142273#issuecomment-948225922
      remoteNixpkgsPatches = [{
        meta.description = "#295107: basalt-monado: init at release-673cc5c6";
        url =
          "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/295107.patch";
        hash = "sha256-qKwJKenK6QYYyz27l/xuoUrAzTKobhJRhbxD0z7kWlo=";
      }];
      originPkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      nixpkgs = originPkgs.applyPatches {
        name = "nixpkgs-patched";
        src = inputs.nixpkgs;
        patches = map originPkgs.fetchpatch remoteNixpkgsPatches;
      };

      # nixosSystem = import (nixpkgs + "/nixos/lib/eval-config.nix");
      nixosSystem = inputs.nixpkgs.lib.nixosSystem;
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
