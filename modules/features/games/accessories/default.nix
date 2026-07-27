{ ... }:

{
  flake.nixosModules.game-accessories = { ... }: {
    hardware.xone.enable = true;
    hardware.new-lg4ff.enable = true;
  };
}
