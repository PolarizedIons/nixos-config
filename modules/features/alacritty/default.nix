{
  self,
  inputs,
  lib,
  ...
}:

{

  flake.nixosModules.alacritty = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      alacritty
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.alacritty = inputs.wrappers.wrappers.alacritty.wrap {
      inherit pkgs;

      flags."--config-file" = lib.mkForce ./config.toml;
    };
  };
}
