{ pkgs, config, lib, system, inputs, ... }:

{
  config = lib.mkIf (config.setup.desktop-environment == "plasma") {

    services.desktopManager.plasma6.enable = true;

    # environment.systemPackages = with pkgs; [ catppuccin-kde ];

    # qt = {
    #   enable = true;
    #   platformTheme = "kde";
    #   style = "adwaita-dark";
    # };

    programs.dconf.enable = true;

    # KDE has its own tablet driver
    hardware.opentabletdriver.enable = lib.mkForce false;
  };
}
