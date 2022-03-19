{pkgs, is-laptop, ...}: 

let wallpaper = import ../../theming/wallpaper.nix { inherit pkgs; };
in
{
    services.xserver = {
        enable = true;
layout = "us";


  libinput.enable = true;
  libinput.touchpad.naturalScrolling = true;
        desktopManager = {
            xterm.enable = false;
        };

        displayManager.lightdm = {
            enable = true;
            background = wallpaper;
        };
    };
}
