{ ... }:

{
  flake.nixosModules.localisation = { ... }: {
    time.timeZone = "Africa/Johannesburg";

    i18n.defaultLocale = "en_ZA.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
  };
}
