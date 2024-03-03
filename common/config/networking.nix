{ config, lib, ... }: {
  networking.networkmanager.enable = true;

  networking.nameservers = config.setup.networking.nameservers;
  networking.useDHCP = lib.mkForce true;
  networking.firewall.enable = false;
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };
}
