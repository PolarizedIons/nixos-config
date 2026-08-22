{ self, ... }:

{
  flake.nixosModules.obs = { pkgs, ... }: {

    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi # AMD hardware acceleration
        obs-gstreamer
        obs-vkcapture
        obs-move-transition
        obs-3d-effect
      ];
    };

    security.polkit.enable = true;
  };
}
