{ pkgs, lib, config, ... }:

let
  wallpaper = import ../../theming/wallpaper.nix { inherit pkgs; };
  # consts
  primary-monitor = config.setup.primary-monitor;
  monitors = config.setup.monitors;
  monitor-count = count monitors;

  # helper functions
  elemAt = builtins.elemAt;
  count = x: (lib.lists.count (y: true) x);
  toStr = builtins.toString;
  xrandr-right = i:
    "--output ${elemAt monitors (i - 1)} --auto --left-of ${
      elemAt monitors i
    } ";
  xrandr-head = i: [{
    output = "${elemAt monitors (i - 1)}";
    primary =
      if primary-monitor == (elemAt monitors (i - 1)) then true else false;
  }];

  gen-xrandr-screens = i:
    if monitor-count == 0 then
      ""
    else
      (if i == 1 then "${pkgs.xorg.xrandr}/bin/xrandr " else "")
      + (if i < monitor-count then
        (xrandr-right i) + (gen-xrandr-screens (i + 1))
      else
        "");

  gen-xrandr-heads = i:
    if monitor-count == 0 then
      [ ]
    else
      (if i <= monitor-count then
        (xrandr-head i) ++ (gen-xrandr-heads (i + 1))
      else
        [ ]);
in {
  hardware.opengl.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";

    videoDrivers = [ config.setup.video-driver ];

    libinput.enable = config.setup.is-laptop;
    libinput.touchpad.naturalScrolling = config.setup.is-laptop;

    desktopManager = { xterm.enable = false; };

    displayManager.lightdm = {
      enable = true;
      background = wallpaper;
    };

    exportConfiguration = true;
    xrandrHeads = gen-xrandr-heads 1;
    displayManager.setupCommands = ''
      ${gen-xrandr-screens 1}
    '';

    environment.systemPackages = [ numlockx ];
  };
}
