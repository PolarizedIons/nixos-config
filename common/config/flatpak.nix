{ config, lib, ... }: {

  config =
    lib.mkIf config.setup.flatpak.enable { services.flatpak.enable = true; };
}
