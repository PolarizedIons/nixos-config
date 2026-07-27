{ ... }:

{
  flake.nixosModules.tailscale = { ... }: {
    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = "client";
    networking.search = [ "tail55af7.ts.net" ];
  };
}
