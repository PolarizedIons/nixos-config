{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.chatting.enable {
    nixpkgs.overlays = [ (import ../../overlays/discord.nix) ];

    environment.systemPackages = with pkgs; [ discord noisetorch ];
  };
}
