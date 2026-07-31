{
  inputs,
  self,
  lib,
  ...
}:

{

  flake.nixosModules.zen = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      zen
    ];
  };

  perSystem =
    { pkgs, ... }:
    {
      packages = rec {
        zen = inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default;
        browser = lib.mkOverride 70 zen;
      };
    };
}
