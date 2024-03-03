{ pkgs, config, lib, ... }:

{
  config = lib.mkIf (config.setup.desktop-environment == "plasma") {

    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma6.enable = true;
    #services.xserver.displayManager.defaultSession = "plasmawayland";
    services.xserver.displayManager.sddm.wayland.enable = true;

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    programs.dconf.enable = true;

    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };
}
