{ lib, ... }:

{
  flake.nixosModules.nix-config = { ... }: {
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        substituters = lib.mkForce [ "https://nix-cache.dievds.net" ];
        trusted-public-keys = lib.mkForce [
          "nix-cache.dievds.net:lUf2rDhqyF+Dbt8uPUvp78xG0Zi58Tm748l85Log9uE="
        ];
      };
    };
  };
}
