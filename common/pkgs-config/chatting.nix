{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.coding.enable {
    environment.systemPackages = with pkgs; [ discord ];
  };
}
