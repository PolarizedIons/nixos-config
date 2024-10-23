{ config, lib, ... }:

{
  config = lib.mkIf config.setup.tailscale.enable {
    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = "client";

    networking.nameservers = [ "100.100.100.100" ];
    networking.search = [ "tail55af7.ts.net" "devices.home.polarizedions.net" ];
  };
}
