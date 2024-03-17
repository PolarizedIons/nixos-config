{ lib, config, pkgs, inputs, system, ... }:
with lib; {
  config = mkIf config.setup.gaming.enable {
    environment.systemPackages = with pkgs; [
      # minecraft
      prismlauncher

      # waiting on https://github.com/NixOS/nixpkgs/pull/289149
      inputs.getchoo-pkgs.packages.${system}.modrinth-app
    ];

    programs.steam.enable = true;
    hardware.xone.enable = true;
  };
}
