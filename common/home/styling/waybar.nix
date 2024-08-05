{ config, setup, lib, pkgs, ... }:

let

  spotify_now_playing = pkgs.writeShellScript "spotify.sh" ''
    str="";
    if [[ $(echo -n "$(${pkgs.playerctl}/bin/playerctl -p spotify status 2> /dev/null)")  == "Paused" ]]; then
      str="";
    fi

    str="$str  $(${pkgs.playerctl}/bin/playerctl -p spotify metadata title) - $(${pkgs.playerctl}/bin/playerctl -p spotify metadata artist)"
    echo $str | sed 's/\(.\{25\}\).*/\1…/'
  '';

in {
  config = lib.mkIf (setup.desktop-environment == "hyprland") {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          modules-left = [ "hyprland/window" ];
          modules-center = [ "clock" "cpu" "memory" ];
          modules-right = [
            "custom/spotify"
            # "network"
            "pulseaudio"
            "battery"
            "tray"
          ];

          "hyprland/window" = {
            icon = true;
            icon-size = 18;
            separate-outputs = true;
            "rewrite" = {
              "(.*) — Mozilla Firefox" = "$1";
              "(.*) - Discord" = "$1";
              "(.*) - (.*) - Visual Studio Code" = "[$2] $1";
            };
            on-scroll-up = "hyprctl dispatch split:workspace -1";
            on-scroll-down = "hyprctl dispatch split:workspace +1";
          };

          clock = {
            interval = 1;
            format = ''
              <span foreground="#${config.colorScheme.palette.base0A}"></span>  {:%a. %d %b. %H:%M:%S}'';
            tooltip = false;
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

          "custom/spotify" = {
            exec = "${spotify_now_playing}";
            exec-if = "pgrep spotify";
            interval = 5;
            format = "{} {icon} ";
            format-icons = {
              default = ''
                <span foreground="#${config.colorScheme.palette.base0B}"></span>'';
            };
            # escape = true;
            tooltip = false;
            on-click = "${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
            on-scroll-up = "${pkgs.playerctl}/bin/playerctl -p spotify next";
            on-scroll-down =
              "${pkgs.playerctl}/bin/playerctl -p spotify previous";
          };

          network = {
            tooltip = false;
            format-wifi = ''
              <span foreground="#${config.colorScheme.palette.base0D}"></span>'';
            format-ethernet = ''
              <span foreground="#${config.colorScheme.palette.base0D}"></span>'';
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
  };
}
