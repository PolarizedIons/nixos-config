{ ... }:

{
  flake.nixosModules.vm-gpu =
    { pkgs, ... }:
    let
      vmName = "win11";
      gpuPci = "0000:07:00.0";
      gpuAudioPci = "0000:07:00.1";
      gpuId = "1002 73ff";
      gpuAudioId = "1002 ab28";
      gpuDriver = "amdgpu";

      gpuHook = pkgs.writeShellScript "gpu-passthrough-hook" ''
        GUEST="$1"
        OPERATION="$2"
        SUBOPERATION="$3"

        GPU="${gpuPci}"
        AUDIO="${gpuAudioPci}"

        if [ "$GUEST" != "${vmName}" ]; then
          exit 0
        fi


        if [ "$OPERATION" = "prepare" ] && [ "$SUBOPERATION" = "begin" ]; then
          systemctl stop display-manager.service || true
          sleep 2

          ${pkgs.procps}/bin/pkill niri || true
          ${pkgs.procps}/bin/pkill xwayland-satellite || true
          sleep 2


          # for vt in /sys/class/vtconsole/vtcon*; do
          #   if [ -e "$vt/bind" ]; then
          #     echo 0 > "$vt/bind" || true
          #   fi
          # done
          # sleep 1


          echo "$GPU" > "/sys/bus/pci/devices/$GPU/driver/unbind"
          echo "$AUDIO" > "/sys/bus/pci/devices/$AUDIO/driver/unbind"
          sleep 1

          modprobe -r "${gpuDriver}"
          sleep 1

          modprobe vfio-pci

          echo "${gpuId}" > /sys/bus/pci/drivers/vfio-pci/new_id
          echo "${gpuAudioId}" > /sys/bus/pci/drivers/vfio-pci/new_id
          sleep 2

          exit 0
        fi


        if [ "$OPERATION" = "stopped" ] && [ "$SUBOPERATION" = "end" ]; then
          echo "$GPU" > /sys/bus/pci/drivers/vfio-pci/unbind || true
          echo "$AUDIO" > /sys/bus/pci/drivers/vfio-pci/unbind || true
          sleep 1

          echo "${gpuId}" > /sys/bus/pci/drivers/vfio-pci/remove_id || true
          echo "${gpuAudioId}" > /sys/bus/pci/drivers/vfio-pci/remove_id || true
          sleep 1

          modprobe "${gpuDriver}"
          sleep 3

          echo "$GPU" > /sys/bus/pci/drivers/amdgpu/bind || true
          sleep 3

          echo "$AUDIO" > /sys/bus/pci/drivers_probe || true
          sleep 2

          # for vt in /sys/class/vtconsole/vtcon*; do
          #   if [ -e "$vt/bind" ]; then
          #     echo 1 > "$vt/bind" || true
          #   fi
          # done
          # sleep 2


          systemctl restart display-manager.service
          sleep 5

          exit 0
        fi
      '';
    in
    {
      specialisation.vfio.configuration = { ... }: {
        system.nixos.tags = [ "vfio" ];

        virtualisation.libvirtd = {
          enable = true;

          onBoot = "ignore";
          onShutdown = "shutdown";

          hooks.qemu = {
            "gpu-passthrough" = gpuHook;
          };
        };

        programs.virt-manager.enable = true;

        #
        # VFIO modules are available at boot, but vfio-pci
        # does not claim the GPU automatically.
        #
        boot.kernelModules = [
          "vfio"
          "vfio_pci"
          "vfio_iommu_type1"
        ];

        boot.extraModprobeConfig = ''
          options vfio-pci disable_vga=1
        '';
      };
    };
}
