{ inputs, system, pkgs, config, ... }:

let
  inherit (inputs.nix-colors.lib.contrib { inherit pkgs; }) gtkThemeFromScheme;

in rec {
  imports = [ ./alacritty.nix ./rofi.nix ./waybar.nix ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 32;
  };

  gtk = {
    enable = true;

    theme = {
      package = gtkThemeFromScheme { scheme = colorScheme; };
      name = colorScheme.slug;
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
}
