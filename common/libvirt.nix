{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.libvirt.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.ovmf.enable = true;
        qemu.swtpm.enable = true;
        qemu.package = pkgs.pkgs.qemu_kvm;
        qemu.ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    programs.dconf.enable = true;
    environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
    environment.systemPackages = with pkgs; [ virt-manager ];
    users.users.polarizedions.extraGroups =
      [ "libvirtd" "kvm" "qemu-libvirtd" ];
  };
}
