{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.setup.media.enable {
    environment.systemPackages = with pkgs; [
      gimp3
      qpwgraph
      vlc

      # whiteboard
      lorien

      # casting
      mkchromecast

      localsend
    ];

    # obs virtual camera
    boot.extraModulePackages = with config.boot.kernelPackages;
      [ v4l2loopback ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    security.polkit.enable = true;
  };
}
