{ lib, config, pkgs, unstable, ... }:
with lib; {
  config = mkIf config.setup.coding.enable {
    environment.systemPackages = with pkgs; [
      minecraft
      unstable.prismlauncher
    ];
    programs.steam.enable = true;
  };
}
