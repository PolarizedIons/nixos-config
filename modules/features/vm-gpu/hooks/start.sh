#!/run/current-system/sw/bin/bash
set -x

# Stop display manager so nothing is using the GPU
systemctl stop display-manager.service
sleep 2

# Unbind GPU + audio from amdgpu/snd_hda_intel
echo 0000:07:00.0 > /sys/bus/pci/devices/0000:07:00.0/driver/unbind 2>/dev/null
echo 0000:07:00.1 > /sys/bus/pci/devices/0000:07:00.1/driver/unbind 2>/dev/null

# Unload amdgpu (may fail if still referenced — that's usually fine)
modprobe -r amdgpu

# Load vfio-pci and bind explicitly to the GPU + audio IDs
modprobe vfio-pci
echo 1002 73ff > /sys/bus/pci/drivers/vfio-pci/new_id
echo 1002 ab28 > /sys/bus/pci/drivers/vfio-pci/new_id
