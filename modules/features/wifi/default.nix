{ config, ... }:

{
  flake.nixosModules.wifi = { pkgs, ... }: {
    networking.wireless = {
      enable = true;
      userControlled = true;
      allowAuxiliaryImperativeNetworks = true;
    };
    users.users."${config.username}".extraGroups = ["wpa_supplicant"];
    environment.systemPackages = with pkgs; [
      wpa_supplicant_gui
    ];
  };
}
