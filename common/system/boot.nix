{ pkgs, ... }: {

  boot = {
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = with pkgs;
        [ (catppuccin-plymouth.override { variant = "mocha"; }) ];
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    loader.timeout = 3;
  };
}
