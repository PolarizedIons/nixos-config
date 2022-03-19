{ pkgs, ... }:
let
  gtk2theme = {
    package = pkgs.spacx-gtk-theme;
    name = "spacx";
  };

  iconTheme = {
    package = pkgs.tela-icon-theme;
    name = "tela";
  };

in
import ./gtk2Theme.nix {
  theme = gtk2theme;
  icons = iconTheme;
}