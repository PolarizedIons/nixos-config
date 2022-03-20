{ pkgs, config, ... }:

let
  terminal = import ../../shell/terminal.nix { inherit pkgs; };
  rofi = import ../rofi.nix { inherit pkgs; };
  wallpaper = import ../../../theming/wallpaper.nix { inherit pkgs; };
  polybar = import ../polybar/polybar.nix { inherit pkgs; };

  i3-config-text = import ./i3-config.nix {
    inherit pkgs config terminal rofi wallpaper polybar;
  };

  i3-config-file = pkgs.writeTextFile {
    name = "i3.conf";
    text = i3-config-text;
  };
in {
  services.xserver = {
    displayManager = { defaultSession = "none+i3"; };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      configFile = i3-config-file;
      extraPackages = with pkgs; [ i3lock-fancy ];
    };
  };
}
