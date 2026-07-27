## PolarizedIon's NixOS Configuration

```bash
# Rebuild & switch
sudo nixos-rebuild --flake .# switch

# Test in a vm
nix build .#nixosConfigurations.vm.config.system.build.vm --impure && ./result/bin/run-*-vm
```
