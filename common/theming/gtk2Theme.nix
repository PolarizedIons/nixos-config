{ pkgs, theme, icons }:

let
  gtk2rc = pkgs.writeText "iconrc" ''
    gtk-icon-theme-name = "${icons.name}"
    gtk-theme-name = "${theme.name}"
  '';
  themeEnv = {
    GTK_PATH =
      "${theme.package}/share/themes/${theme.name}/gtk-2.0:${pkgs.gtk3.out}:$GTK_PATH";
    GTK2_RC_FILES =
      "${gtk2rc}:${theme.package}/share/themes/${theme.name}/gtk-2.0/gtkrc:$GTK2_RC_FILES";
    GTK_THEME = "${theme.name}";
    GDK_PIXBUF_MODULE_FILE =
      "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
    GTK_DATA_PREFIX = "${theme.package}";
    GTK_EXEC_PREFIX = "${theme.package}";
    GTK_IM_MODULE = "xim";
  };
in {
  environment.variables = themeEnv;
  environment.systemPackages =
    [ pkgs.gtk-engine-murrine theme.package icons.package ];
  qt5.enable = true;
  qt5.platformTheme = "gtk2";
  qt5.style = "gtk2";
}
