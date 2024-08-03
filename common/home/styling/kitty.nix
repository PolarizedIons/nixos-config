{ config, setup, lib, ... }:

{
  config = lib.mkIf (setup.desktop-environment == "hyprland") {
    programs.kitty = {
      enable = true;
      settings = {
        foreground = "#${config.colorScheme.palette.base05}";
        background = "#${config.colorScheme.palette.base00}";

        # black
        color0 = "#${config.colorScheme.palette.base00}";
        color8 = "#${config.colorScheme.palette.base03}";

        # red
        color1 = "#${config.colorScheme.palette.base08}";
        color9 = "#${config.colorScheme.palette.base08}";

        # green
        color2 = "#${config.colorScheme.palette.base0B}";
        color10 = "#${config.colorScheme.palette.base0B}";

        # yellow
        color3 = "#${config.colorScheme.palette.base0A}";
        color11 = "#${config.colorScheme.palette.base0A}";

        # blue
        color4 = "#${config.colorScheme.palette.base0D}";
        color12 = "#${config.colorScheme.palette.base0D}";

        # magenta
        color5 = "#${config.colorScheme.palette.base0E}";
        color13 = "#${config.colorScheme.palette.base0E}";

        # cyan
        color6 = "#${config.colorScheme.palette.base0C}";
        color14 = "#${config.colorScheme.palette.base0C}";

        # white
        color7 = "#${config.colorScheme.palette.base04}";
        color15 = "#${config.colorScheme.palette.base06}";

      };
    };
  };
}
