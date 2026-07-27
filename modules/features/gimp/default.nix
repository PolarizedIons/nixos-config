{ self, ... }:

{
  flake.nixosModules.gimp = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      gimp
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.gimp = pkgs.gimp3;
  };
}
