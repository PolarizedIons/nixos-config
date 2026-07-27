{ self, ... }:

{
  flake.nixosModules.discord = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      discord
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.discord = pkgs.discord;
  };
}
