{ lib, config, pkgs, inputs, system, ... }:
with lib; {
  imports = [ inputs.spplice.nixosModules.${system}.spplice ];
  config = mkIf config.setup.gaming.enable {
    environment.systemPackages = with pkgs; [
      heroic

      # minecraft
      prismlauncher
      modrinth-app
    ];

    programs.spplice.enable = true;

    programs.steam.enable = true;
    hardware.xone.enable = true;
    # hardware.xpadneo.enable = true;
  };
}
