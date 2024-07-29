{ pkgs, config, lib, inputs, system, setup, ... }:

{
  config = lib.mkIf (setup.desktop-environment == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        # inputs.hyprland-plugins.packages.${system}.hyprbars
        inputs.hyprsplit.packages.${system}.hyprsplit
      ];

      settings = {
        misc = { disable_hyprland_logo = true; };

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
        ] ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (x:
            let
              ws =
                (let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10)));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]) 10));

        bindm = [
          # mouse movements
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        general = {
          gaps_in = "5";
          gaps_out = "8, 15, 15, 15";
          border_size = "3";
          "col.active_border" = "rgba(fe8019ff)";
          "col.inactive_border" = "rgba(504945ff)";

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
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''
            '<span foreground="##cad3f5">Password...</span>'
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
          };
          clock = {
            interval = 1;
            format =
              ''<span foreground="#fabd2f"></span>  {:%a. %d %b. %H:%M:%S}'';
          };
          cpu = {
            interval = 5;
            tooltip = false;
            format = ''<span foreground="#8ec07c"></span>  {}%'';
          };

          memory = {
            tooltip = false;
            format = ''<span foreground="#d3869b"></span>  {used}G'';
          };

          network = {
            tooltip = false;
            format-wifi = ''{essid} <span foreground="#83a598"></span>'';
            format-ethernet =
              ''{ipaddr}/{cidr} <span foreground="#83a598"></span>'';
            format-disconnected = ''<span foreground="#83a598"></span'';
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-muted = "";
            format-icons = {
              "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
              "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
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
            on-click = "pavucontrol";
            ignored-sinks = [ "Easy Effects Sink" ];
            reverse-scrolling = true;
          };
          battery = {
            interval = 60;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-icons = [ "" "" "" "" "" ];
            max-length = 25;
          };

          tray = {
            icon-size = 21;
            spacing = 10;
            show-passive-items = false;
          };
        };
      };

      style = ''
        @define-color bg #282828;
        @define-color red-dim #cc241d;
        @define-color green-dim #98971a;
        @define-color yellow-dim #d79921;
        @define-color blue-dim #458588;
        @define-color purple-dim #b16286;
        @define-color aqua-dim #689d6a;
        @define-color gray-dim #a89984;

        @define-color gray #928374;
        @define-color red #fb4934;
        @define-color green #b8bb26;
        @define-color yellow #fabd2f;
        @define-color blue #83a598;
        @define-color purple #d3869b;
        @define-color aqua #8ec07c;
        @define-color fg #ebdbb2;

        @define-color bg0_h #1d2021;
        @define-color bg0 #282828;
        @define-color bg1 #3c3836;
        @define-color bg2 #504945;
        @define-color bg3 #665c54;
        @define-color bg4 #7c6f64;
        @define-color orange-dim #d65d0e;

        @define-color bg0_s #32302f;
        @define-color fg4 #a89984;
        @define-color fg3 #bdae93;
        @define-color fg2 #d5c4a1;
        @define-color fg1 #ebdbb2;
        @define-color fg0 #fbf1c7;
        @define-color orange #fe8019;


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

          background: @bg1;
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
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    gtk = {
      enable = true;

      theme = {
        package = pkgs.flat-remix-gtk;
        name = "Flat-Remix-GTK-Grey-Darkest";
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
  };
}
