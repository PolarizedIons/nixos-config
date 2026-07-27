{
  inputs,
  self,
  lib,
  ...
}:

{
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages."${pkgs.stdenv.hostPlatform.system}".niri;
    };

    # TODO: make part of config and not part of system path
    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };

  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.niri = inputs.wrappers.wrappers.niri.wrap {
        inherit pkgs;

        package = pkgs.niri; # [ inputs'.niri.packages.niri-stable ];

        settings = {
          extraConfig = ''
            input {
                keyboard {
                    numlock
                }
                touchpad {
                    tap
                    natural-scroll
                }

                focus-follows-mouse "max-scroll-amount"="0%" {
                }
              }

              switch-events {
                lid-close { spawn "${lib.getExe self'.packages.noctalia-shell}" "ipc" "call" "lockScreen" "lock"; }
              }
          '';

          layout = {
            gaps = 16;
            preset-column-widths = [
              { proportion = 0.333333; }
              { proportion = 0.5; }
              { proportion = 0.666667; }
            ];
            preset-window-heights = [
              { proportion = 0.5; }
              { proportion = 1.0; }
            ];
            default-column-width = {
              proportion = 1.0;
            };
            focus-ring.off = _: { };
            border = {
              width = 2;
              active-color = "#ffc87f";
              inactive-color = "#505050";
              urgent-color = "#9b0000";
            };
            shadow = {
              on = _: { };
              softness = 30;
              spread = 5;
              offset = _: {
                props = {
                  x = 0;
                  y = 0;
                };
              };
              color = "#0007";
            };
          };
          prefer-no-csd = _: { };
          screenshot-path = null;
          window-rules = [
            {
              matches = [
                {
                  app-id = "firefox$";
                  title = "^Picture-in-Picture$";
                }
              ];
              open-floating = true;
            }

            {
              geometry-corner-radius = 6;
              clip-to-geometry = true;
            }
          ];
          binds = {
            "Mod+Shift+Slash".show-hotkey-overlay = _: { };
            "Mod+Return".spawn-sh = lib.getExe self'.packages.alacritty;
            "Mod+Space".spawn-sh = lib.getExe self'.packages.fuzzel;

            "Mod+H".focus-column-left = _: { };
            "Mod+Left".focus-column-left = _: { };
            "Mod+J".focus-window-or-workspace-down = _: { };
            "Mod+Down".focus-window-or-workspace-down = _: { };
            "Mod+K".focus-window-or-workspace-up = _: { };
            "Mod+Up".focus-window-or-workspace-up = _: { };
            "Mod+L".focus-column-right = _: { };
            "Mod+Right".focus-column-right = _: { };

            "Mod+Shift+H".move-column-left = _: { };
            "Mod+Shift+Left".move-column-left = _: { };
            "Mod+Shift+J".move-window-down-or-to-workspace-down = _: { };
            "Mod+Shift+Down".move-window-down-or-to-workspace-down = _: { };
            "Mod+Shift+K".move-window-up-or-to-workspace-up = _: { };
            "Mod+Shift+Up".move-window-up-or-to-workspace-up = _: { };
            "Mod+Shift+L".move-column-right = _: { };
            "Mod+Shift+Right".move-column-right = _: { };

            "Mod+Page_Down".focus-workspace-down = _: { };
            "Mod+U".focus-workspace-down = _: { };
            "Mod+Page_Up".focus-workspace-up = _: { };
            "Mod+I".focus-workspace-up = _: { };

            "Mod+Shift+Page_Down".move-workspace-down = _: { };
            "Mod+Shift+U".move-workspace-down = _: { };
            "Mod+Shift+Page_Up".move-workspace-up = _: { };
            "Mod+Shift+I".move-workspace-up = _: { };

            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;

            "Mod+Shift+1".move-column-to-workspace = 1;
            "Mod+Shift+2".move-column-to-workspace = 2;
            "Mod+Shift+3".move-column-to-workspace = 3;
            "Mod+Shift+4".move-column-to-workspace = 4;
            "Mod+Shift+5".move-column-to-workspace = 5;
            "Mod+Shift+6".move-column-to-workspace = 6;
            "Mod+Shift+7".move-column-to-workspace = 7;
            "Mod+Shift+8".move-column-to-workspace = 8;
            "Mod+Shift+9".move-column-to-workspace = 9;

            "Mod+Tab".focus-workspace-previous = _: { };

            "Mod+O" = _: {
              props.repeat = false;
              content.toggle-overview = _: { };
            };

            "Mod+Q" = _: {
              props.repeat = false;
              content.close-window = _: { };
            };

            "Mod+BracketLeft".consume-or-expel-window-left = _: { };
            "Mod+BracketRight".consume-or-expel-window-right = _: { };

            "Mod+R".switch-preset-column-width = _: { };
            "Mod+Shift+R".switch-preset-window-height = _: { };
            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";
            "Mod+Shift+Minus".set-column-width = "-10%";
            "Mod+Shift+Equal".set-column-width = "+10%";

            "Mod+F".maximize-column = _: { };
            "Mod+Shift+F".fullscreen-window = _: { };

            "Mod+V".toggle-window-floating = _: { };

            "Print".screenshot = _: { };

            "Mod+Escape" = _: {
              props.allow-inhibiting = false;
              content.toggle-keyboard-shortcuts-inhibit = _: { };
            };

            "XF86AudioRaiseVolume" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
            };
            "XF86AudioLowerVolume" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
            };
            "XF86AudioMute" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };
            "XF86AudioMicMute" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            };

            "XF86MonBrightnessUp" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "${lib.getExe pkgs.brightnessctl} --class=backlight set +10%";
            };
            "XF86MonBrightnessDown" = _: {
              props.allow-when-locked = true;
              content.spawn-sh = "${lib.getExe pkgs.brightnessctl} --class=backlight set -10%";
            };
          };
          spawn-at-startup = [
            (lib.getExe self'.packages.noctalia-shell)
          ];
        };
      };
    };
}
