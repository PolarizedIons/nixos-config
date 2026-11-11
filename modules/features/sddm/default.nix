{ self, lib, ... }:

{

  flake.nixosModules.sddm = { pkgs, config, ... }: {
    services.xserver.enable = true;
    services.displayManager.sddm = {
      enable = true;
      package = lib.mkForce self.packages."${pkgs.stdenv.hostPlatform.system}".sddm;
      wayland.enable = true;
      autoNumlock = true;
      theme = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";

      extraPackages = with pkgs; [
        kdePackages.qtmultimedia
        qt6.qtvirtualkeyboard
      ];

      settings.Wayland.CompositorCommand = lib.mkIf config.hardware.asahi.enable "${pkgs.weston}/bin/weston --shell=kiosk --drm-device=card1";
    };
  };

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.sddm = pkgs.kdePackages.sddm;
    };
}
