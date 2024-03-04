{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.setup.media.enable {
    environment.systemPackages = with pkgs; [

      obs-studio
      vlc

      # whiteboard
      lorien

      # casting
      mkchromecast
    ];
  };
}
