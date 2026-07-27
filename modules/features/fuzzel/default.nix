{
  inputs,
  self,
  lib,
  ...
}:

{
  flake.nixosModules.fuzzel = { pkgs, ... }: {

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

        settings = {

        };
      };
    };
}
