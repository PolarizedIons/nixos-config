{ ... }:

{
  flake.nixosModules.networking = {
    networking = {
      nameservers = [ "192.168.0.15" ];
      search = [ "home" ];
      useDHCP = true;
      firewall.enable = false;
    };
  };
}
