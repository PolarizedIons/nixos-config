{ lib, config, ... }:
let
  listDirFiles = toRead:
    map (n: builtins.replaceStrings [ ".nix" ] [ "" ] n) (builtins.attrNames
      (lib.filterAttrs (n: _: n != "default.nix" && !lib.hasPrefix "." n)
        (builtins.readDir toRead)));
  browsers = listDirFiles ./system/browser;
  shells = listDirFiles ./home/shell;
  DEs = listDirFiles ./system/desktop-env;
in with lib; {
  options.setup = {
    machine-name = mkOption { type = types.str; };

    browsers = mkOption {
      type = types.listOf (types.enum browsers);
      default = [ "firefox" ];
    };

    users = mkOption {
      type = types.listOf (types.submodule {
        options = {
          login = mkOption { type = types.str; };
          name = mkOption { type = types.str; };
          email = mkOption { type = types.str; };
          shell = mkOption {
            type = types.enum shells;
            default = "zsh";
          };
        };
      });
      default = [{
        login = "polarizedions";
        name = "Stephan";
        email = "me@polarizedions.net";
      }];
    };

    desktop-environment = mkOption {
      type = types.enum DEs;
      default = "gnome";
    };

    # only used for things like hyprland
    monitors = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption { type = types.str; };
          resolution = {
            width = mkOption {
              type = types.int;
              default = 1920;
            };
            height = mkOption {
              type = types.int;
              default = 1080;
            };
          };
        };
      });
      default = [ ];
    };
    modifierKey = mkOption {
      type = types.str;
      default = "SUPER";
    };

    video-driver = mkOption { type = types.str; };
    display-link.enable = mkEnableOption "Enable displaylink driver";

    networking = {
      nameservers = mkOption {
        type = types.listOf types.str;
        default = [ "192.168.0.15" "1.1.1.1" "8.8.8.8" ];
      };
    };

    timezone = mkOption {
      type = types.str;
      default = "Africa/Johannesburg";
    };

    work-mode.enable = mkEnableOption "Enable work environablement";
    wooting.enable = mkEnableOption "Enable wooting udev rules";
    nix-alien.enable = mkEnableOption "Enable nix-alien";
    coding.enable = mkEnableOption "Setup coding environment";
    flatpak.enable = mkEnableOption "Setup flatpak";
    media.enable = mkEnableOption "Setup media applications";
    gaming.enable = mkEnableOption "Setup games";
    chatting.enable = mkEnableOption "Setup chatting programs";
    keybase.enable = mkEnableOption "Setup keybase";
    music.enable = mkEnableOption "Setup music programs";
    libvirt.enable = mkEnableOption "Enable libvirt & Virt-Manager";
    vr.enable = mkEnableOption "Enable VR";
  };
}
