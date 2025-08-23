{ lib, config, pkgs, inputs, system, ... }:
with lib; {
  imports = [ inputs.spplice.nixosModules.${system}.spplice ];
  config = mkIf config.setup.gaming.enable {
    environment.systemPackages = with pkgs; [
      steamtinkerlaunch

      heroic
      prismlauncher
    ];

    programs.spplice.enable = true;

    programs.steam.enable = true;
    programs.steam.extraCompatPackages = with pkgs; [ steamtinkerlaunch ];
    hardware.xone.enable = true;
    # hardware.xpadneo.enable = true;

    hardware.new-lg4ff.enable = true;
  };
}
