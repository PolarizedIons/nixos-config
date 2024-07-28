{ pkgs, config, lib, inputs, system, setup, ... }:

{
  config = lib.mkIf (setup.desktop-environment == "hyprland") {
    wayland.windowManager.hyprland = {
      enable = true;

      plugins = [
        # getting version mis-match, even though they say it shouldn't happen with flakes
        # inputs.hyprland-plugins.packages.${system}.hyprbars
      ];

      settings = {
        misc = { disable_hyprland_logo = true; };

        "$mod" = "SUPER";

        monitor = [ "eDP-1, 1920x1080, 0x0, 1" ",preferred,auto,auto" ];

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
          "$mod, C, killactive"
          "$mod, V, togglefloating"
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

        windowrule = [ "float, ^(kitty)$" ];

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
          position = "top";
          height = 30;
          output = [ "eDP-1" "HDMI-A-1" ];
          modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
          modules-center = [ "sway/window" "custom/hello-from-waybar" ];
          modules-right = [ "mpd" "custom/mymodule#with-css-id" "temperature" ];

          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };
          "custom/hello-from-waybar" = {
            format = "hello {}";
            max-length = 40;
            interval = "once";
            exec = pkgs.writeShellScript "hello-from-waybar" ''
              echo "from within waybar"
            '';
          };
        };
      };
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
