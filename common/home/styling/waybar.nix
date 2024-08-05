{ config, setup, lib, pkgs, ... }:

let

  spotify_now_playing = pkgs.writeShellScript "spotify.sh" ''
    icon="";
    if [[ $(echo -n "$(${pkgs.playerctl}/bin/playerctl -p spotify status 2> /dev/null)")  == "Paused" ]]; then
      icon=" | ";
    fi

    str="$(${pkgs.playerctl}/bin/playerctl -p spotify metadata title) - $(${pkgs.playerctl}/bin/playerctl -p spotify metadata artist)"
    trimmed="$(echo $str | sed 's/\(.\{25\}\).*/\1…/')"
    echo "$icon$trimmed" # text
    echo "$str" # tooltip
  '';

  spotify_album_cover = pkgs.writeShellScript "spotify-cover.sh" ''
    touch /tmp/spotify-cover.id
    last_track_id=$(cat /tmp/spotify-cover.id)
    track_id=$(${pkgs.playerctl}/bin/playerctl -p spotify metadata mpris:trackid)

    # If the track id is empty, we are not playing anything
    if [[ -x "$last_track_id" ]] && [[ -n "$last_track_id" ]]
    then
      exit 0
    fi

    # If the track id is the same as the last one, we don't need to update the cover, so just output
    if [[ $last_track_id == $track_id ]]
    then
      echo "/tmp/spotify-cover.jpeg"
      exit 0
    fi

    # Save the new track id
    echo $track_id > /tmp/spotify-cover.id

    # Get the album art
    album_art=$(${pkgs.playerctl}/bin/playerctl -p spotify metadata mpris:artUrl)

    # If the album art is empty, return early
    if [[ -z $album_art ]] 
    then
      exit 0
    fi

    # Download the album art & output
    curl -s "$album_art" --output "/tmp/spotify-cover.jpeg"
    echo "/tmp/spotify-cover.jpeg"
  '';

  next_calendar_event = pkgs.writeShellScript "calendar.sh" ''
    touch ~/.waybar-calendar.url
    calendar_url=$(cat ~/.waybar-calendar.url)
    if [[ -z $calendar_url ]]
    then
      exit 1
    fi

    # Download the calendar
    curl -s $calendar_url --output /tmp/waybar-calendar.ics

    # Get the next calendar event
    event=$(${pkgs.icalcli}/bin/icalcli agenda -o nof -o nol --nostarted --military -n 1 | head --lines 4 | tail --lines 1);
    start=$(echo $event | awk -F'[ ]' '{print $3}');
    end=$(echo $event | awk -F'[ ]' '{print $5}');
    description=$(echo $event | awk -F"$end[ ]+" '{print $2}');
    trimmed_description=$(echo $description | sed 's/\(.\{15\}\).*/\1…/')

    echo "$start → $end · $trimmed_description" # text
    echo "$description" # tooltip
  '';

in {
  config = lib.mkIf (setup.desktop-environment == "hyprland") {
    home.file.".icalcli.py".text = ''
      from icalcli import ICSInterface
      backend_interface = ICSInterface("/tmp/waybar-calendar.ics")
    '';

    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          modules-left = [ "hyprland/window" ];
          modules-center = [
            "custom/caledar"
            "clock"

            # "cpu" "memory" 
          ];
          modules-right = [
            "image#spotify"
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
              "(.*) - Google Chrome" = "$1";
              "(.*) - (.*) - Visual Studio Code" = "[$2] $1";
              "(\\*)? ?(.*) \\(DM\\) - (.*) - Slack" = "[$3$1] >$2";
              "(\\*)? ?(.*) \\(Channel\\) - (.*) - Slack" = "[$3$1] #$2";
            };
            on-scroll-up = "hyprctl dispatch split:workspace -1";
            on-scroll-down = "hyprctl dispatch split:workspace +1";
          };

          "custom/caledar" = {
            exec = "${next_calendar_event}";

            interval = 300;
            format = ''
              <span foreground="#${config.colorScheme.palette.base0E}"></span>  {}'';
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

          "image#spotify" = {
            class = "spotify";
            size = 24;
            exec = "${spotify_album_cover}";
            exec-if = "pgrep spotify";
            interval = 1;
            on-click = "${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
            on-scroll-up = "${pkgs.playerctl}/bin/playerctl -p spotify next";
            on-scroll-down =
              "${pkgs.playerctl}/bin/playerctl -p spotify previous";
          };

          "custom/spotify" = {
            exec = "${spotify_now_playing}";
            exec-if = "pgrep spotify";
            interval = 1;
            format = "{} {icon} ";
            format-icons = {
              default = ''
                <span foreground="#${config.colorScheme.palette.base0B}"></span>'';
            };
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

        .empty {
          background: transparent;
          margin: 0;
          padding: 0;
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
        #cpu, #image.spotify {
          margin-right: 0;
          padding-right: 5px;
          border-top-right-radius: 0;
          border-bottom-right-radius: 0;
        }

        #memory, #custom-spotify {
          margin-left: 0;
          padding-left: 5px;
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
