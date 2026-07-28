{
  config,
  inputs,
  self,
  moduleWithSystem,
  ...
}:

{
  flake.nixosModules.steamdeck = moduleWithSystem (
    { pkgs, ... }:
    let
      modules = with self.nixosModules; [
        shared
        kde-plasma
      ];
    in
    {
      imports = modules // [
        inputs.steamos-nix.nixosModules.default
      ];

      environment.systemPackages = with pkgs; [
        maliit-keyboard
        ryubing
        steam-rom-manager
      ];

      jovian.steam.enable = true;
      jovian.steam.autoStart = true;
      jovian.steam.desktopSession = "plasma";
      jovian.devices.steamdeck.enable = true;
      jovian.devices.steamdeck.autoUpdate = true;
      jovian.hardware.has.amd.gpu = true;
      jovian.steam.user = "${config.username}";
    }
  );
}
