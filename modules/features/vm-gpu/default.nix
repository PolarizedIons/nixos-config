{ ... }:

{

  flake.nixosModules.vm-gpu = { pkgs, ... }: {
    specialisation.vfio.configuration =
      { ... }:
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

          if [ "$GUEST" != "${vmName}" ]; then
            exit 0
          fi

          if [ "$OPERATION" = "prepare" ] && [ "$SUBOPERATION" = "begin" ]; then
            systemctl stop display-manager.service
            sleep 1
            pkill niri
            pkill xwayland-satellite
            sleep 1

            echo "${gpuPci}" > "/sys/bus/pci/devices/${gpuPci}/driver/unbind" 2>/dev/null
            echo "${gpuAudioPci}" > "/sys/bus/pci/devices/${gpuAudioPci}/driver/unbind" 2>/dev/null

            modprobe -r "${gpuDriver}"

            modprobe vfio-pci
            echo "${gpuId}" > /sys/bus/pci/drivers/vfio-pci/new_id 2>/dev/null
            echo "${gpuAudioId}" > /sys/bus/pci/drivers/vfio-pci/new_id 2>/dev/null
          fi

          if [ "$OPERATION" = "release" ] && [ "$SUBOPERATION" = "end" ]; then
            echo "${gpuPci}" > "/sys/bus/pci/devices/${gpuPci}/driver/unbind" 2>/dev/null
            echo "${gpuAudioPci}" > "/sys/bus/pci/devices/${gpuAudioPci}/driver/unbind" 2>/dev/null

            echo "${gpuId}" > /sys/bus/pci/drivers/vfio-pci/remove_id 2>/dev/null
            echo "${gpuAudioId}" > /sys/bus/pci/drivers/vfio-pci/remove_id 2>/dev/null

            modprobe -r vfio-pci
            modprobe "${gpuDriver}"

            sleep 2
            systemctl start display-manager.service
          fi
        '';
      in
      {
        system.nixos.tags = [ "vfio" ];

        virtualisation.libvirtd = {
          enable = true;
          onBoot = "ignore";
          onShutdown = "shutdown";

          hooks.qemu =

            {
              "gpu-passthrough" = gpuHook;
            };
        };
        programs.virt-manager.enable = true;

        # vfio-pci must be loadable, but NOT bound at boot —
        # the hook script does the binding live, so no kernelParams
        # ids= here and no amdgpu blacklist.
        boot.kernelModules = [
          "vfio"
          "vfio_pci"
          "vfio_iommu_type1"
        ];

        # Load vfio-pci module early enough to be ready, but without
        # claiming the GPU (no .ids= option set here).
        boot.extraModprobeConfig = ''
          options vfio-pci disable_vga=1
        '';
      };
  };
}
