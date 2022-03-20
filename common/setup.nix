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

    coding.enable = mkEnableOption "Setup coding environment";
    gaming.enable = mkEnableOption "Setup games";
    chatting.enable = mkEnableOption "Setup chatting programs";
    keybase.enable = mkEnableOption "Setup keybase";
    music.enable = mkEnableOption "Setup music programs";
  };
}
