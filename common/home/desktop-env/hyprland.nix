{ pkgs, config, lib, inputs, system, setup, ... }:

let
  inherit (inputs.nix-colors.lib.contrib { inherit pkgs; })
    nixWallpaperFromScheme;
in {
  config = lib.mkIf (setup.desktop-environment == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        # inputs.hyprland-plugins.packages.${system}.hyprbars
        inputs.hyprsplit.packages.${system}.hyprsplit
      ];

      settings = {
        misc = { disable_hyprland_logo = true; };

        exec-once =
          [ "hyprpaper" "wl-paste -t text --watch clipman store --no-persist" ];

        "$mod" = "SUPER";
        "$terminal" = "alacritty";

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
          "$mod, Return, exec, $terminal"
          "$mod, Space, exec, rofi -show drun -show-icons"
          "$mod, D, exec, ${builtins.elemAt setup.browsers 0}"
          "$mod, F, fullscreen"
          "$mod, M, exit"
          "$mod, C, killactive"
          "$mod, Z, exec, clipman pick -t rofi"
          ''
            $mod, V, exec, hyprctl --batch "dispatch togglefloating ; dispatch centerwindow 1"''
          "$mod, P, pseudo, # dwindle"
          "$mod, X, togglesplit, # dwindle"
          "$mod, L, exec, hyprlock"
          ", Print, exec, hyprshot -m region --clipboard-only"

          "$mod, Minus, split:grabroguewindows"

          ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5 "
          ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5 "
          ", XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -m"
          ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"

          ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%"
          ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-"
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

    wayland.windowManager.hyprland.systemd = {
      variables = [ "--all" ];
      enableXdgAutostart = true;
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
  };
}
