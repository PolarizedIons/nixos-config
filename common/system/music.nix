{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.music.enable {
    environment.systemPackages = with pkgs;
      [
        spotify
        # tidal-hifi
      ];
  };
}
