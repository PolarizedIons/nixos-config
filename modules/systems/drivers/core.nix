{ ... }:

{
  flake.nixosModules.core-drivers = { ... }: {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
