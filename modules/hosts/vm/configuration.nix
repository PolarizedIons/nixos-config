{ lib, config, ... }:

{
  flake.nixosModules.vm = { ... }: {
    imports = [
      # Include the results of the hardware scan.
      <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
      <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
    ];

    networking.hostName = "test-vm";

    users.users.${config.username}.password = "123";

    services.qemuGuest.enable = true;
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot = {
      growPartition = true;
    };

    virtualisation = {
      diskSize = 16000; # MB
      memorySize = 6000; # MB
      cores = 4;
      writableStoreUseTmpfs = false;
      qemu.options = [
        "-device virtio-vga-gl"
        "-display sdl,gl=on,show-cursor=on"
        "-audio pa,model=hda"
      ];
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
