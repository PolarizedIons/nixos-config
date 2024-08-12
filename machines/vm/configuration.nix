{ config, pkgs, inputs, system, ... }: {
  imports = [ # Include the results of the hardware scan.
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
    ../../common
  ];
  programs.awsvpnclient.enable = true;

  setup.machine-name = "my-vm";
  setup.desktop-environment = "gnome";
  setup.browsers = [ "firefox" ];
  setup.media.enable = false;
  setup.chatting.enable = false;
  setup.music.enable = false;
  setup.work-mode.enable = false;

  setup.users = [{
    login = "vm-user";
    name = "VM User";
    email = "nix@polarizedions.net";
  }];
  users.users.vm-user.password = "123";

  services.qemuGuest.enable = true;
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };

  boot = {
    growPartition = true;
    # kernelParams = [ "console=ttyS0 boot.shell_on_fail" ];
    # loader.timeout = 5;
  };

  virtualisation = {
    diskSize = 16000; # MB
    memorySize = 6000; # MB
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
