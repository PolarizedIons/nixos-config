{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.setup.media.enable {
    environment.systemPackages = with pkgs; [
      gimp
      qpwgraph
      obs-studio
      vlc

      # whiteboard
      lorien

      # casting
      mkchromecast
    ];
  };
}
