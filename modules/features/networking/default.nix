{ ... }:

{
  flake.nixosModules.networking = { lib, ... }: {
    # Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;

    # Implicitly enables IWD and disables wpa_supplicant
    networking.networkmanager.wifi.backend = "iwd";

    networking = {
      nameservers = [ "192.168.0.15" ];
      search = [ "home" ];
      useDHCP = lib.mkDefault false; # Enabled per interface
      firewall.enable = false;
    };
  };
}
