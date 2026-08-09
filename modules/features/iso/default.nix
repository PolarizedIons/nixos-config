{ lib, ... }:

{
  flake.nixosModules.iso = { modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

    boot.supportedFilesystems.zfs = lib.mkForce false;
    networking.useDHCP = lib.mkForce true;
    boot.loader.timeout = lib.mkForce 10;

    isoImage.squashfsCompression = "lz4";

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
