{ self, ... }:

{
  flake.nixosModules.obs = { pkgs, ... }: {

    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      package = self.packages."${pkgs.stdenv.hostPlatform.system}".obs;
    };

    security.polkit.enable = true;
  };

  perSystem = { pkgs, ... }: {
    packages.obs =
      (pkgs.wrapOBS {
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
      }).overrideAttrs
        (oldAttrs: {
          buildCommand =
            builtins.replaceStrings [ "rm -r $out/share/obs/obs-plugins" "echo" ] [ "" "# echo" ]
              oldAttrs.buildCommand;
        });
  };
}
