{ self, ... }:

{
  flake.nixosModules.discord = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      discord
      overlayed
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.discord = pkgs.discord;
    packages.overlayed = pkgs.overlayed;
  };
}
