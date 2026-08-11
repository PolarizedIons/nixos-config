{ ... }:

{
  flake.nixosModules.networking = {
    networking = {
      nameservers = [ "192.168.0.15" ];
      search = [ "home" ];
      useDHCP = false; # Enabled per interface
      firewall.enable = false;
    };
  };
}
