{ config, setup, lib, pkgs, ... }:

{
  config = lib.mkIf (setup.desktop-environment == "hyprland") {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;

      extraConfig = { show-icons = true; };

      theme = builtins.toFile "rofi-theme.rasi" ''
        /*******************************************************************************
         * ROFI VERTICAL THEME USING THE NORD COLOR PALETTE 
         * User                 : LR-Tech               
         * Theme Repo           : https://github.com/lr-tech/rofi-themes-collection
         * Nord Project Repo    : https://github.com/arcticicestudio/nord
         *******************************************************************************/

        * {
            font:   "Jetbrains Mono 12";

            nord0:     #${config.colorScheme.palette.base00};
            nord1:     #${config.colorScheme.palette.base01};
            nord2:     #${config.colorScheme.palette.base02};
            nord3:     #${config.colorScheme.palette.base03};

            nord4:     #${config.colorScheme.palette.base04};
            nord5:     #${config.colorScheme.palette.base05};
            nord6:     #${config.colorScheme.palette.base06};

            nord7:     #${config.colorScheme.palette.base07};
            nord8:     #${config.colorScheme.palette.base08};
            nord9:     #${config.colorScheme.palette.base09};
            nord10:    #${config.colorScheme.palette.base0A};
            nord11:    #${config.colorScheme.palette.base0B};

            nord12:    #${config.colorScheme.palette.base0C};
            nord13:    #${config.colorScheme.palette.base0D};
            nord14:    #${config.colorScheme.palette.base0E};
            nord15:    #${config.colorScheme.palette.base0F};

            background-color:   transparent;
            text-color:         @nord4;
            accent-color:       @nord8;

            margin:     0px;
            padding:    0px;
            spacing:    0px;
        }

        window {
            background-color:   @nord0;
            border-color:       @accent-color;

            location:   center;
            width:      480px;
            border:     1px;
        }

        inputbar {
            padding:    8px 12px;
            spacing:    12px;
            children:   [ prompt, entry ];
        }

        prompt, entry, element-text, element-icon {
            vertical-align: 0.5;
        }

        prompt {
            text-color: @accent-color;
        }

        listview {
            lines:      8;
            columns:    1;

            fixed-height:   false;
        }

        element {
            padding:    8px;
            spacing:    8px;
        }

        element normal urgent {
            text-color: @nord13;
        }

        element normal active {
            text-color: @accent-color;
        }

        element alternate active {
            text-color: @accent-color;
        }

        element selected {
            text-color: @nord0;
        }

        element selected normal {
            background-color:   @accent-color;
        }

        element selected urgent {
            background-color:   @nord13;
        }

        element selected active {
            background-color:   @nord8;
        }

        element-icon {
            size:   0.75em;
        }

        element-text {
            text-color: inherit;
        }
      '';
    };
  };
}
