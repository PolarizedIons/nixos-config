{ self, ... }:

{

  flake.nixosModules.alacritty = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      alacritty
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.alacritty = pkgs.alacritty;
  };
}
