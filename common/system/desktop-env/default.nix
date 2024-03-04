{ pkgs, lib, config, ... }:

let
  all = lib.filterAttrs (n: _: n != "default.nix" && !lib.hasPrefix "." n)
    (builtins.readDir ./.);

in {
  imports = map (p: ./. + "/${p}") (builtins.attrNames all);

  services.dbus.enable = true;
  hardware.opengl.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";

    videoDrivers = [ config.setup.video-driver ];

    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    libinput.touchpad.disableWhileTyping = false;
  };

  environment.systemPackages = with pkgs; [ numlockx ];

  xdg.portal = {
    enable = true;
    # config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-kde
      # xdg-desktop-portal-gtk
    ];
    wlr = { enable = true; };
  };
}
