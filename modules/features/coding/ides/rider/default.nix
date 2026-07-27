{ self, ... }:

{
  flake.nixosModules.rider = { pkgs, ... }: {
    imports = [ self.nixosModules.dotnet ];

    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      rider
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.rider = pkgs.jetbrains.rider;
  };
}
