{ config, ... }:

{
  flake.nixosModules.wifi = { pkgs, ... }: {
    networking.wireless.enable = true;
  };
}
