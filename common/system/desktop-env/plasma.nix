{ pkgs, config, lib, ... }:

{
  config = lib.mkIf (config.setup.desktop-environment == "plasma") {

    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma6.enable = true;
    services.xserver.displayManager.sddm.wayland.enable = true;

    #  This causes black screen on unlock, no idea why
    # qt = {
    #   enable = true;
    #   platformTheme = "gnome";
    #   style = "adwaita-dark";
    # };

    programs.dconf.enable = true;
  };
}
