{
  description = "PolarizedIons's Machine Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-alien.url = "github:thiagokokada/nix-alien";

    teraflops.url = "github:aanderse/teraflops";
    teraflops.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # spplice.url = "github:PolarizedIons/spplice-flake/cpp-beta";
    # spplice.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    steamos-nix.url = "github:Jovian-Experiments/Jovian-NixOS";
    steamos-nix.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    import-tree.url = "github:vic/import-tree";

    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs.nixpkgs.follows = "";
    impermanence.inputs.home-manager.follows = "";
  };

  outputs =
    {
      flake-parts,
      import-tree,
      ...
    }@inputs:

    flake-parts.lib.mkFlake {
      inherit inputs;
    } (import-tree ./modules);
}
