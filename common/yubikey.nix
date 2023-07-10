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

  # solokey
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a2ca", TAG+="uaccess", SYMLINK+="solokey"
  '';
}
