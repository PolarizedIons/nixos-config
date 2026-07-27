{ self, ... }:

{
  flake.nixosModules.spotify = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      spotify
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.spotify = pkgs.spotify;
  };
}
