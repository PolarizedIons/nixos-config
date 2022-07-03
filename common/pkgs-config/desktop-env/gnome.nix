{ pkgs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = (with pkgs; [ gnome-photos gnome-tour ])
    ++ (with pkgs.gnome; [
      gnome-music
      gedit # text editor
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
    gnome.adwaita-icon-theme
    nordic
    gnome.gnome-tweaks
  ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}
