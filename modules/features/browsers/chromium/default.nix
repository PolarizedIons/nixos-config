{ self, ... }:

{

  flake.nixosModules.chromium = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      chromium
    ];
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.chromium = pkgs.chromium;
    };
}
