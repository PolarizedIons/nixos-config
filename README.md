## PolarizedIon's NixOS Configuration

```bash
# Rebuild & switch
sudo nixos-rebuild --flake .# switch

# Test in a vm
nix build .#nixosConfigurations.vm.config.system.build.vm --impure && ./result/bin/run-*-vm

# Build iso:
nix build .#nixosConfigurations.iso.config.system.build.isoImage
ls result/iso/

# Test iso
nix-shell -p qemu
qemu-system-x86_64 -enable-kvm -m 1024 -cdrom result/iso/nixos-*.iso
```
