{ pkgs, config, lib, ... }:

{
  config = lib.mkIf (config.setup.desktop-environment == "plasma") {

    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    #  This causes black screen on unlock, no idea why
    # qt = {
    #   enable = true;
    #   platformTheme = "gnome";
    #   style = "adwaita-dark";
    # };

    programs.dconf.enable = true;
  };
}
