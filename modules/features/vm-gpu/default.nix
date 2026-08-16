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

        # Only handle our VM.
        if [ "$GUEST" != "${vmName}" ]; then
          exit 0
        fi

        # VM START
        if [ "$OPERATION" = "prepare" ] && [ "$SUBOPERATION" = "begin" ]; then

          systemctl stop display-manager.service || true
          sleep 2

          ${pkgs.procps}/bin/pkill -f niri || true
          ${pkgs.procps}/bin/pkill -f xwayland-satellite || true
          sleep 2

          for vt in /sys/class/vtconsole/vtcon*; do
            if [ -e "$vt/bind" ]; then
              echo 0 > "$vt/bind" || true
            fi
          done
          sleep 1

          # Unbind GPU
          if [ -e "/sys/bus/pci/devices/$GPU/driver/unbind" ]; then
            echo "$GPU" > "/sys/bus/pci/devices/$GPU/driver/unbind"
          fi

          # Unbind HDMI/DP
          if [ -e "/sys/bus/pci/devices/$AUDIO/driver/unbind" ]; then
            echo "$AUDIO" > "/sys/bus/pci/devices/$AUDIO/driver/unbind"
          fi
          sleep 1

          modprobe -r "${gpuDriver}"
          sleep 1
          modprobe vfio-pci

          echo "${gpuId}" > /sys/bus/pci/drivers/vfio-pci/new_id
          echo "${gpuAudioId}" > /sys/bus/pci/drivers/vfio-pci/new_id
          sleep 2

          # Allocate 16GB (8192 * 2MB) of hugepages
          echo 1 > /proc/sys/vm/compact_memory # doesn't hurt
          sync && echo 3 > /proc/sys/vm/drop_caches
          echo 8192 > /proc/sys/vm/nr_hugepages

          exit 0
        fi


        #
        # VM STOPPED
        #
        if [ "$OPERATION" = "stopped" ] &&
           [ "$SUBOPERATION" = "end" ]; then

          echo 0 > tee /proc/sys/vm/nr_hugepages

          # Remove GPU from vfio-pci.
          if [ -e "/sys/bus/pci/drivers/vfio-pci/unbind" ]; then
            echo "$GPU" > /sys/bus/pci/drivers/vfio-pci/unbind || true
            echo "$AUDIO" > /sys/bus/pci/drivers/vfio-pci/unbind || true
          fi
          sleep 1

          echo "${gpuId}" > /sys/bus/pci/drivers/vfio-pci/remove_id || true
          echo "${gpuAudioId}" > /sys/bus/pci/drivers/vfio-pci/remove_id || true
          sleep 1

          modprobe "${gpuDriver}"
          sleep 3

          if [ -e "/sys/bus/pci/drivers/amdgpu/bind" ]; then
            echo "$GPU" > /sys/bus/pci/drivers/amdgpu/bind || true
          fi
          sleep 3

          echo "$AUDIO" > /sys/bus/pci/drivers_probe || true
          sleep 2

          for vt in /sys/class/vtconsole/vtcon*; do
            if [ -e "$vt/bind" ]; then
              echo 1 > "$vt/bind" || true
            fi
          done
          sleep 2

          sleep 5
          systemctl restart display-manager.service

          exit 0
        fi

        exit 0
      '';
    in
    {
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
}
