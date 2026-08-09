{ ... }:

{
  flake.nixosModules.iso = { modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
    isoImage.squashfsCompression = "lz4";
  };
}
