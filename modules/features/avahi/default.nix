{ ... }:

{
  flake.nixosModules.avahi = { ... }: {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      settings = {
        publish = {
          disable-publishing = false;
          publish-addresses = true;
          publish-domain = true;
          publish-hinfo = true;
          disable-user-service-publishing = false;
          publish-workstation = true;
        };
      };
    };
  };
}
