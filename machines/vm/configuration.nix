{ config, pkgs, ... }:
let
  
machine-name = "my-vm";

 unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/44391b11e13f9aa4b67a8de335c332076f9c91b3)
    # reuse the current configuration
    { config = config.nixpkgs.config; };

in
{
  imports =
    [ # Include the results of the hardware scan.
      <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
      <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
      (
        import ../../common/common.nix { 
          is-laptop = false;
          inherit machine-name pkgs config unstable;
        }
      )
    ];
services.qemuGuest.enable = true;
users.users.polarizedions.password = "password";
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot = {
      growPartition = true;
      # kernelParams = [ "console=ttyS0 boot.shell_on_fail" ];
      loader.timeout = 5;
    };

    virtualisation = {
      diskSize = 8000; # MB
      memorySize = 2048; # MB
      writableStoreUseTmpfs = false;
    };

  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
