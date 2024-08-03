{ config, pkgs, ... }: {
  imports = [ # Include the results of the hardware scan.
    <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
    ../../common
  ];

  setup.machine-name = "my-vm";
  setup.desktop-environment = "hyprland";
  setup.modifierKey = "Control_L";
  setup.browsers = [ "chromium" "google-chrome-stable" "firefox" ];
  # setup.gaming.enable = true;
  # setup.media.enable = true;
  # setup.chatting.enable = true;
  # setup.music.enable = true;
  # setup.work-mode.enable = false;

  services.xserver.videoDrivers = [ "qxl" ];
  environment.systemPackages = [ pkgs.xorg.xf86videoqxl ];

  setup.users = [{
    login = "vm-user";
    name = "VM User";
    email = "nix@polarizedions.net";
  }];
  users.users.vm-user.password = "123";

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
  };
  virtualisation.qemu.options = [ "-device virtio-vga" ];
  security.sudo.wheelNeedsPassword = false;

  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "vm-user";
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
