{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.libvirt.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
        qemu.package = pkgs.pkgs.qemu_kvm;
        allowedBridges = [ "virbr0" "br0" ];
      };
    };
    programs.dconf.enable = true;
    environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
    environment.systemPackages = with pkgs; [ virt-manager ];

    users.users = builtins.listToAttrs (builtins.map (u: {
      name = u.login;
      value = { extraGroups = [ "libvirtd" "kvm" "qemu-libvirtd" ]; };
    }) config.setup.users);
  };
}
