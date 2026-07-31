{ self, lib, ... }:

{

  flake.nixosModules.chromium = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      chromium
    ];
  };

  perSystem =
    { pkgs, ... }:
    {
      packages = rec {
        chromium = pkgs.chromium;
        browser = lib.mkOverride 100 chromium;
      };
    };
}
