{ inputs, ... }:

{
  flake.nixosModules.mac-drivers = { ... }: {
    imports = [
      inputs.apple-silicon.nixosModules.default
    ];

    # Enable basic nixos-apple-silicon support.
    hardware.asahi.enable = true;
  };
}
