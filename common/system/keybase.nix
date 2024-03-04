{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.coding.enable {
    services = {
      keybase = { enable = true; };
      kbfs.enable = true;
    };

    environment.systemPackages = with pkgs; [ keybase-gui ];
  };
}
