{ lib, ... }:
with lib; {
  options.setup = {
    machine-name = mkOption { type = types.str; };
    is-laptop = mkOption {
      type = types.bool;
      default = false;
    };
    is-vm = mkOption {
      type = types.bool;
      default = false;
    };
    monitors = mkOption {
      type = types.listOf types.string;
      default = [];
    };
    primary-monitor = mkOption {
      type = types.str;
      default = if (lib.lists.count (x: true) monitors) == 0 then "" else builtins.elemAt monitor 0;
    };
    video-driver = mkOption {
      type = types.str;
    };

    coding.enable = mkEnableOption "Setup coding environment";
    gaming.enable = mkEnableOption "Setup games";
    chatting.enable = mkEnableOption "Setup chatting programs";
    keybase.enable = mkEnableOption "Setup keybase";
    music.enable = mkEnableOption "Setup music programs";
  };
}
