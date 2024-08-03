{ pkgs, config, lib, inputs, system, setup, ... }:

let
  inherit (inputs.nix-colors.lib.contrib { inherit pkgs; })
    gtkThemeFromScheme nixWallpaperFromScheme;

in {
  config = lib.mkIf (setup.desktop-environment == "hyprland") {

    colorScheme = inputs.nix-colors.colorSchemes.material-darker;

    programs = {
      kitty = {
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

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        # inputs.hyprland-plugins.packages.${system}.hyprbars
        inputs.hyprsplit.packages.${system}.hyprsplit
      ];

      settings = {
        misc = { disable_hyprland_logo = true; };

        exec-once = [ "hyprpaper" ];

        "$mod" = "SUPER";

        monitor = let
          calcOffset = index: offset:
            if index == 0 then
              offset
            else
              (calcOffset (index - 1) (offset
                + (builtins.elemAt setup.monitors index).resolution.width));
          monitorConfig = builtins.genList (i:
            let
              name = (builtins.elemAt setup.monitors i).name;
              x = toString (calcOffset i 0);
              width =
                toString (builtins.elemAt setup.monitors i).resolution.width;
              height =
                toString (builtins.elemAt setup.monitors i).resolution.height;
            in "${name},${width}x${height},${x}x0,1")
            (builtins.length setup.monitors);
        in monitorConfig ++ [ ",preferred,auto,auto" ];

        input.numlock_by_default = true;

        input.touchpad = {
          natural_scroll = true;
          disable_while_typing = false;
          middle_button_emulation = true;
          clickfinger_behavior = true;
          tap-and-drag = true;
        };

        gestures = { workspace_swipe = true; };

        bind = [
          "$mod, Return, exec, kitty"
          "$mod, Space, exec, rofi -show drun -show-icons"
          "$mod, F, exec, ${builtins.elemAt setup.browsers 0}"
          "$mod, M, exit"
          "$mod, C, killactive"
          ''
            $mod, V, exec, hyprctl --batch "dispatch togglefloating ; dispatch centerwindow 1"''
          "$mod, P, pseudo, # dwindle"
          "$mod, X, togglesplit, # dwindle"
          "$mod, L, exec, hyprlock"
          ", Print, exec, hyprshot -m region --clipboard-only"

          "$mod, Minus, split:grabroguewindows"
        ] ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (x:
            let
              ws =
                (let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10)));
            in [
              "$mod, ${ws}, split:workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, split:movetoworkspace, ${toString (x + 1)}"
            ]) 10));

        bindm = [
          # mouse movements
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        bindl = [ ",switch:Lid Switch, exec, hyprlock" ];

        general = {
          gaps_in = "5";
          gaps_out = "8, 15, 15, 15";
          border_size = "3";
          "col.active_border" = "rgba(${config.colorScheme.palette.base0D}ff)";
          "col.inactive_border" =
            "rgba(${config.colorScheme.palette.base02}ff)";

          layout = "dwindle";
        };

        dwindle = {
          pseudotile =
            true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # You probably want this
        };

        decoration = {
          rounding = 5;

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };

        animations = { enabled = true; };

        windowrule = [ "float,class:(floating)" ];

        windowrulev2 = [
          "suppressevent maximize, class:.*" # "You'll probably like this. " what does this mean????

          # hide xwaylandvideobridge window
          "opacity 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
          "maxsize 1 1,class:^(xwaylandvideobridge)$"
          "noblur,class:^(xwaylandvideobridge)$"
        ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 5;
          hide_cursor = false;
          no_fade_in = false;
        };

        background = [{
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }];

        input-field = [{
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "#${config.colorScheme.palette.base04}";
          inner_color = "#${config.colorScheme.palette.base02}";
          outer_color = "#${config.colorScheme.palette.base00}";
          outline_thickness = 5;
          placeholder_text = ''
            <span foreground="##${config.colorScheme.palette.base03}">Password...</span>
          '';
          shadow_passes = 2;
        }];
      };
    };

    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          modules-left = [ "hyprland/window" ];
          modules-center = [ "clock" "cpu" "memory" ];
          modules-right = [ "network" "pulseaudio" "battery" "tray" ];

          "hyprland/window" = {
            icon = true;
            icon-size = 18;
            separate-outputs = true;
            "rewrite" = {
              "(.*) — Mozilla Firefox" = "$1";
              "(.*) - (.*) - Visual Studio Code" = "$2 - $1";
            };
          };
          clock = {
            interval = 1;
            format = ''
              <span foreground="#${config.colorScheme.palette.base0A}"></span>  {:%a. %d %b. %H:%M:%S}'';
          };
          cpu = {
            interval = 5;
            tooltip = false;
            format = ''
              <span foreground="#${config.colorScheme.palette.base0B}"></span>  {}%'';
          };

          memory = {
            tooltip = false;
            format = ''
              <span foreground="#${config.colorScheme.palette.base0E}"></span>  {used}G'';
          };

          network = {
            tooltip = false;
            format-wifi = ''
              {essid} <span foreground="#${config.colorScheme.palette.base0D}"></span>'';
            format-ethernet = ''
              {ipaddr}/{cidr} <span foreground="#${config.colorScheme.palette.base0D}"></span>'';
            format-disconnected = ''
              <span foreground="#${config.colorScheme.palette.base0D}"></span'';
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{desc} {volume}% {icon}";
            format-muted = "muted {icon}";
            format-icons = {
              headphone = "";
              "hands-free" = "";
              headset = "";
              phone = "";
              "phone-muted" = "";
              portable = "";
              car = "";
              default = [ "" "" ];
            };
            scroll-step = 1;
            on-click =
              "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            reverse-scrolling = true;
          };
          battery = {
            interval = 60;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-charging = "+{capacity}% {icon}";
            format-discharging = "-{capacity}% {icon}";
            format-time = "{H}h{m}m";
            format-icons = [ "" "" "" "" "" ];
            max-length = 25;
          };

          tray = {
            icon-size = 21;
            spacing = 5;
            show-passive-items = false;
          };
        };
      };

      style = ''
        @define-color bg #${config.colorScheme.palette.base02};
        @define-color red-dim #${config.colorScheme.palette.base08};
        @define-color green-dim #${config.colorScheme.palette.base0B};
        @define-color yellow-dim #${config.colorScheme.palette.base0A};
        @define-color blue-dim #${config.colorScheme.palette.base0D};
        @define-color purple-dim #${config.colorScheme.palette.base0E};
        @define-color aqua-dim #${config.colorScheme.palette.base0C};
        @define-color gray-dim #${config.colorScheme.palette.base03};

        @define-color gray #${config.colorScheme.palette.base03};
        @define-color red #${config.colorScheme.palette.base08};
        @define-color green #${config.colorScheme.palette.base0B};
        @define-color yellow #${config.colorScheme.palette.base0A};
        @define-color blue #${config.colorScheme.palette.base0D};
        @define-color purple #${config.colorScheme.palette.base0E};
        @define-color aqua #${config.colorScheme.palette.base0C};
        @define-color fg #${config.colorScheme.palette.base05};

        * {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 14px;
        }

        /* The bar itself */
        #waybar {
          background: transparent;
        }

        /* Hide window name widget when there's no active window */
        #waybar.empty #window {
          background: transparent;
        }

        #waybar > .horizontal {
          padding: 5px;
          background: @bg;
        }

        /* All widgets */
        widget > * {
          padding: 4px 10px;
          margin-right: 5px;

          border-radius: 10px;

          background: @gray-dim;
          color: @fg;
        }

        /* Bring system info to the same "box" */
        #cpu {
          margin-right: 0;
          border-top-right-radius: 0;
          border-bottom-right-radius: 0;
        }

        #memory {
          margin-left: 0;
          border-top-left-radius: 0;
          border-bottom-left-radius: 0;
        }

        #pulseaudio, #battery, #network {
          padding-right: 20px;
        }

        #tray {
          margin-right: 0; /* Remove margin here because it is the last widget */
        }
      '';
    };

    wayland.windowManager.hyprland.systemd = {
      variables = [ "--all" ];
      enableXdgAutostart = true;
    };

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
      size = 32;
    };

    gtk = {
      enable = true;

      theme = {
        package = gtkThemeFromScheme { scheme = config.colorScheme; };
        name = config.colorScheme.slug;
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

    #  Todo make this come from setup.monitors
    services.hyprpaper = let
      wallpaper = nixWallpaperFromScheme {
        scheme = config.colorScheme;
        width = 1920;
        height = 1080;
        logoScale = 5.0;
      };
    in {
      enable = true;
      settings = {
        preload = [ "${wallpaper}" ];
        wallpaper = [ ",${wallpaper}" ];
      };
    };

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
