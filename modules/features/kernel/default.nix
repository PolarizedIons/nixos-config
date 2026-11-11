{ lib, ... }:

{
  flake.nixosModules.kernel = { pkgs, ... }: {
    boot.kernelPackages =  lib.mkDefault pkgs.linuxPackages_latest;
  };
}
