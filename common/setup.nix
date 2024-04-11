{ lib, config, ... }:
with lib; {
  options.setup = {
    machine-name = mkOption { type = types.str; };

    browsers = mkOption {
      type = types.listOf types.str;
      default = [ "firefox" ];
    };

    users = mkOption {
      type = types.listOf (types.submodule {
        options = {
          login = mkOption { type = types.str; };
          name = mkOption { type = types.str; };
          email = mkOption { type = types.str; };
          shell = mkOption {
            type = types.str;
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
      type = types.str;
      default = "gnome";
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
