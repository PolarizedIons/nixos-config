{ ... }:

{
  flake.nixosModules.yubikey = { pkgs, ... }: {
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;

    security.pam = {
      u2f = {
        enable = true;
        settings = {
          cue = true;
        };
      };
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };

    security.pam.u2f.control = "sufficient";
  };
}
