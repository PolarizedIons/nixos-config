{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../../common ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  setup.machine-name = "aegis";
  setup.video-driver = "amdgpu";
  setup.desktop-environment = "plasma";
  setup.browsers = [ "firefox" "chromium" ];
  setup.wooting.enable = true;
  setup.nix-alien.enable = true;
  setup.coding.enable = true;
  setup.flatpak.enable = true;
  setup.media.enable = true;
  setup.gaming.enable = true;
  setup.chatting.enable = true;
  setup.keybase.enable = true;
  setup.music.enable = true;
  setup.libvirt.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

