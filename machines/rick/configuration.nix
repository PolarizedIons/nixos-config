# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:
let
  unstable = import (builtins.fetchTarball
    "https://github.com/nixos/nixpkgs/tarball/44391b11e13f9aa4b67a8de335c332076f9c91b3") {
      config = config.nixpkgs.config;
    };

in {
  imports = [ ./hardware-configuration.nix ../../common ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  setup.machine-name = "rick";
  setup.is-laptop = true;
  setup.coding.enable = true;
  setup.gaming.enable = true;
  setup.chatting.enable = true;
  setup.keybase.enable = true;
  setup.music.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
