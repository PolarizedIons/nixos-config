{ config, setup, lib, ... }:

{
  config = lib.mkIf (setup.desktop-environment == "hyprland") {
    programs.alacritty = {
      enable = true;
      settings = {
        colors = {

          primary = {
            foreground = "#${config.colorScheme.palette.base05}";
            background = "#${config.colorScheme.palette.base00}";
          };
          normal = {
            black = "#${config.colorScheme.palette.base00}";
            red = "#${config.colorScheme.palette.base08}";
            green = "#${config.colorScheme.palette.base0B}";
            yellow = "#${config.colorScheme.palette.base0A}";
            blue = "#${config.colorScheme.palette.base0D}";
            magenta = "#${config.colorScheme.palette.base0E}";
            cyan = "#${config.colorScheme.palette.base0C}";
            white = "#${config.colorScheme.palette.base04}";
          };
        };
      };
    };
  };
}
