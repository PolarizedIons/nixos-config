{
  inputs,
  self,
  lib,
  ...
}:

{
  flake.nixosModules.fuzzel = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      fuzzel
    ];
  };

  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.fuzzel = inputs.wrappers.wrappers.fuzzel.wrap {
        inherit pkgs;

        flags."--config" = lib.mkForce ./config.ini;
      };
    };
}
