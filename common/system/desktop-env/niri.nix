{ pkgs, config, lib, system, inputs, ... }:

{
  imports = [ inputs.noctalia.nixosModules.default ];
  config = lib.mkIf (config.setup.desktop-environment == "niri") {

    nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    programs.niri = { enable = true; };

    environment.systemPackages = with pkgs; [ alacritty fuzzel ];

    services.noctalia-shell.enable = true;

    # programs.regreet.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
  };
}
