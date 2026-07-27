{ inputs, self, ... }:

{

  flake.nixosModules.zen = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      zen
    ];
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.zen = inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default;
    };
}
