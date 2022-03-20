{ pkgs, ... }:
let
  gtk2theme = {
    package = pkgs.spacx-gtk-theme;
    name = "spacx";
  };

  iconTheme = {
    package = pkgs.vimix-icon-theme;
    name = "Vimix-standard-dark";
  };

in import ./gtk2Theme.nix {
  theme = gtk2theme;
  icons = iconTheme;
  inherit pkgs;
}
