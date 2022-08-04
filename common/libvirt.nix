{ lib, config, pkgs, ... }:
with lib; {
  config = mkIf config.setup.libvirt.enable {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [ virt-manager ];
    users.users.polarizedions.extraGroups = [ "libvirtd" ];
  };
}
