{ ... }:

{
  flake.nixosModules.kde-plasma = { ... }: {
    services.desktopManager.plasma6.enable = true;
  };
}
