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

        substituters = lib.mkForce [
          "https://nix-cache.dievds.net"
          "https://cache.nixos.org"
        ];
        trusted-public-keys = lib.mkForce [
          "nix-cache.dievds.net:0G69EXgoJNKzH+BuPdGIeYhJ6iEC9vnhZ2D2PjJ/toY="
        ];
      };
    };
  };
}
