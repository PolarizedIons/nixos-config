#!/run/current-system/sw/bin/bash
set -x

# Unbind from vfio-pci
echo 0000:07:00.0 > /sys/bus/pci/devices/0000:07:00.0/driver/unbind 2>/dev/null
echo 0000:07:00.1 > /sys/bus/pci/devices/0000:07:00.1/driver/unbind 2>/dev/null

# Remove the vfio-pci id bindings so future boots aren't affected
echo 1002 73ff > /sys/bus/pci/drivers/vfio-pci/remove_id 2>/dev/null
echo 1002 ab28 > /sys/bus/pci/drivers/vfio-pci/remove_id 2>/dev/null

modprobe -r vfio-pci

# Rebind to amdgpu
modprobe amdgpu

sleep 2
systemctl start display-manager.service
