{ pkgs, config, ... }: {
  services.udev.packages = [ pkgs.yubikey-personalization ];

  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [ yubioath-flutter ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.u2f = {
    enable = true;
    settings = { cue = true; };
  };

  security.pam.u2f.control =
    (if config.setup.work-mode.enable then "required" else "sufficient");

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
