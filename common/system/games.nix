{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.gaming.enable {
    environment.systemPackages = with pkgs;
      [
        # minecraft
        prismlauncher
      ];
    programs.steam.enable = true;
  };
}
