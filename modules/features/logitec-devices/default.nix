{ ... }:

{
  flake.nixosModules.logitec-devices = {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
