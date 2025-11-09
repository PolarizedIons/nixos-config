{ inputs, system, pkgs, config, ... }:

{

  # stylix = {
  #   enable = true;
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  # };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 32;
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
