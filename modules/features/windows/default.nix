{ ... }:

let
  vm = "win11";
in
{

  flake.nixosModules.vm-gaming-user = { pkgs, ... }: {
    specialisation.gaming.configuration = {

      users.users.gaming = {
        isNormalUser = true;
      };

      services.displayManager = {
        autoLogin = {
          enable = true;
          user = "gaming";
        };
      };

      systemd.services.start-gaming-vm = {
        wantedBy = [ "graphical.target" ];
        after = [ "libvirtd.service" ];
        unitConfig.ConditionPathExists = "!/run/gaming-vm-ran";
        serviceConfig = {
          Type = "simple";
          ExecStart = pkgs.writeShellScript "start-gaming-vm" ''
            virsh="${pkgs.libvirt}/bin/virsh -c qemu:///system"

            touch /run/gaming-vm-ran
            $virsh start ${vm} || exit 1

            # wait until the VM is off
            while [ "$($virsh domstate ${vm})" != "shut off" ]; do
              sleep 5
            done

            ${pkgs.systemd}/bin/systemctl poweroff
          '';
        };
      };

    };
  };
}
