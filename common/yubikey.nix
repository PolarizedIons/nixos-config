{ pkgs, ... }: {
  services.udev.packages = [ pkgs.yubikey-personalization ];

  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [ yubioath-flutter ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.u2f = {
    enable = true;
    cue = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
