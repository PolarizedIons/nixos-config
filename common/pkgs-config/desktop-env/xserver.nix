{ pkgs, config, ... }:

let wallpaper = import ../../theming/wallpaper.nix { inherit pkgs; };
in {
  services.xserver = {
    enable = true;
    layout = "us";

    libinput.enable = config.setup.is-laptop;
    libinput.touchpad.naturalScrolling = config.setup.is-laptop;

    desktopManager = { xterm.enable = false; };

    displayManager.lightdm = {
      enable = true;
      background = wallpaper;
    };
  };
}
