{ pkgs, config, lib, ... }:

{
  config = lib.mkIf (config.setup.desktop-environment == "gnome") {

    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages =
      (with pkgs; [ gnome-photos gnome-tour gedit ]) ++ (with pkgs.gnome; [
        gnome-music
        epiphany # web browser
        geary # email reader
        evince # document viewer
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      adwaita-icon-theme
      nordic
      gnome.gnome-tweaks
    ];
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  };
}
