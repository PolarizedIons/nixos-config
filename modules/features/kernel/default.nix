{ lib, ... }:

{
  flake.nixosModules.kernel = { pkgs, ... }: {
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };
}
