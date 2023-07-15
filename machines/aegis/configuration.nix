{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../../common ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.interfaces.enp3s0.useDHCP = true;
  # boot.kernelPackages = pkgs.linuxPackages_5_15;
  boot.initrd.systemd.enable = true;

  setup.machine-name = "aegis";
  setup.video-driver = "amdgpu";
  setup.monitors = [ "HDMI-0" "DP-1" ];
  setup.primary-monitor = "DP-1";
  setup.network-interfaces.ethernet = "enp4s0";
  setup.coding.enable = true;
  setup.gaming.enable = true;
  setup.chatting.enable = true;
  setup.keybase.enable = true;
  setup.music.enable = true;
  setup.libvirt.enable = true;

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

