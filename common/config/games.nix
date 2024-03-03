{ lib, config, pkgs, unstable, ... }:
with lib; {
  config = mkIf config.setup.gaming.enable {
    environment.systemPackages = [
      # minecraft
      unstable.prismlauncher
    ];
    programs.steam.enable = true;
  };
}
