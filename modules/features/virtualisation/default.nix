{ config, ... }:

{
  flake.nixosModules.virtualisation = { pkgs, lib, ... }: {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
        qemu.package = pkgs.qemu_kvm;
        allowedBridges = [
          "virbr0"
          "br0"
        ];
      };
    };

    programs.dconf.enable = true;
    environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";
    environment.systemPackages = with pkgs; [ virt-manager ];

    users.users."${config.username}".extraGroups = [
      "libvirtd"
      "kvm"
      "qemu-libvirtd"
    ];
  };
}
