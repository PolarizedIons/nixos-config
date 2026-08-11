{ config, ... }:

{
  flake.nixosModules.virtualisation = { pkgs, ... }: {
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

    networking = {
      firewall.trustedInterfaces = [
        "virbr0"
        "br0"
      ];

      interfaces."br0".useDHCP = true;
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
