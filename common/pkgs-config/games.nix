{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.coding.enable {
    environment.systemPackages = with pkgs; [ minecraft polymc ];
    programs.steam.enable = true;
  };
}
