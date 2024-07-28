{ pkgs, config, lib, system, inputs, ... }:

{
  config = lib.mkIf (config.setup.desktop-environment == "plasma") {

    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;

      # forcing Qt5 libs because of https://github.com/NixOS/nixpkgs/issues/292761
      package = pkgs.lib.mkForce pkgs.libsForQt5.sddm;
      extraPackages =
        pkgs.lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
    };

    # theming
    services.displayManager.sddm.theme = "catppuccin-sddm-corners";
    environment.systemPackages = with pkgs; [
      inputs.sddm-catppuccin.packages.${system}.catppuccin-sddm-corners
      catppuccin-kde
    ];

    #  This causes black screen on unlock, no idea why
    qt = {
      enable = true;
      platformTheme = "kde";
      style = "adwaita-dark";
    };

    programs.dconf.enable = true;

    # KDE has its own tablet driver
    hardware.opentabletdriver.enable = lib.mkForce false;
  };
}
