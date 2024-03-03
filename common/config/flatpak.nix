{ config, lib, ... }: {

  config = lib.mkIf config.setup.flatpak.enable {
    xdg.portal.enable = true;
    services.flatpak.enable = true;
  };
}
