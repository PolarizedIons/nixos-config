{ ... }:

{
  flake.nixosModules.logitec-devices = {
    hardware.logitech.wireless = {
      enable = true;
    };
    programs.solaar.enable = true;
  };
}
