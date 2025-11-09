{ inputs, system, pkgs, config, ... }:

{

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 16;
  };

  # gtk = {
  #   enable = true;

  #   # theme = {
  #   #   package = gtkThemeFromScheme { scheme = colorScheme; };
  #   #   name = colorScheme.slug;
  #   # };

  #   # iconTheme = {
  #   #   package = pkgs.adwaita-icon-theme;
  #   #   name = "Adwaita";
  #   # };

  #   # font = {
  #   #   name = "Sans";
  #   #   size = 11;
  #   # };
  # };
}
