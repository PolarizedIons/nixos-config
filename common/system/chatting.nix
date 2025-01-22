{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.chatting.enable {
    environment.systemPackages = with pkgs; [ discord-canary noisetorch ];

    # nixpkgs.overlays = [ (import ../../overlays/discord.nix) ];
  };
}
