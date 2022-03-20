{ pkgs, theme, icons }:

let
  themeEnv = ''
    export GTK2_RC_FILES=${
      pkgs.writeText "iconrc" ''gtk-icon-theme-name="${icons.name}"''
    }:${theme.package}/share/themes/${theme.name}/gtk-2.0/gtkrc:$GTK2_RC_FILES
    export GDK_PIXBUF_MODULE_FILE=$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)
  '';
in {
  environment.extraInit = themeEnv;
  environment.systemPackages = [ theme.package icons.package ];
}
