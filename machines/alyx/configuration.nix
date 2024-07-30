{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../../common ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  setup.machine-name = "alyx";
  setup.video-driver = "intel";
  setup.display-link.enable = true;

  # setup.desktop-environment = "plasma";
  setup.desktop-environment = "hyprland";
  setup.monitors =
    [ { name = "DVI-I-1"; } { name = "HDMI-A-1"; } { name = "eDP-1"; } ];
  setup.browsers = [ "google-chrome" "firefox" ];

  setup.work-mode.enable = true;
  setup.wooting.enable = true;
  setup.nix-alien.enable = true;
  setup.coding.enable = true;
  setup.media.enable = true;
  setup.chatting.enable = true;
  setup.music.enable = true;
  setup.libvirt.enable = true;

  setup.users = [{
    login = "stephan";
    name = "Stephan";
    email = "work@polarizedions.net";
  }];

  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-c067c3b9-a74e-4e62-a5c2-ab2e3ee071e8".device =
    "/dev/disk/by-uuid/c067c3b9-a74e-4e62-a5c2-ab2e3ee071e8";
  boot.initrd.luks.devices."luks-c067c3b9-a74e-4e62-a5c2-ab2e3ee071e8".keyFile =
    "/crypto_keyfile.bin";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

