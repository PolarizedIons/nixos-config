{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.gaming.enable {
    environment.systemPackages = with pkgs; [
      heroic

      # minecraft
      prismlauncher
      modrinth-app
    ];

    programs.steam.enable = true;
    hardware.xone.enable = true;
  };
}
