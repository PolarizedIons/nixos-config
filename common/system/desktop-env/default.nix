{ pkgs, lib, config, ... }:

let all = lib.filterAttrs (n: _: n != "default.nix") (builtins.readDir ./.);

in {
  imports = (map (p: ./. + "/${p}") (builtins.attrNames all));

  services.dbus.enable = true;
  hardware.graphics.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";

    videoDrivers = lib.mkMerge [
      [ config.setup.video-driver ]
      (if config.setup.display-link.enable then [ "displaylink" ] else [ ])
    ];
  };

  # Hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services = {
    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    libinput.touchpad.disableWhileTyping = false;
  };

  environment.systemPackages = with pkgs; [ xwaylandvideobridge ];

  systemd.user.services."xwaylandvideobridge" = {
    description = "xwaylandvideobridge service";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.xwaylandvideobridge}/bin/xwaylandvideobridge";
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    wlr = { enable = true; };
  };
}
