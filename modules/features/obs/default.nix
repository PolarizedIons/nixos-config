{ self, ... }:

{
  flake.nixosModules.obs = { pkgs, config, ... }: {

    programs.obs-studio = {
      enable = true;
      package = self.packages."${pkgs.stdenv.hostPlatform.system}".obs;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };

    # obs virtual camera
    boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    security.polkit.enable = true;
  };

  perSystem = { pkgs, ... }: {
    packages.obs = pkgs.obs-studio;
  };
}
