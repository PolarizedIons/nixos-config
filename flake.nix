{
  description = "PolarizedIons's Machine Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";

    awsvpnclient.url = "github:ymatsiuk/awsvpnclient/main";
    awsvpnclient.inputs.nixpkgs.follows = "nixpkgs";

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
