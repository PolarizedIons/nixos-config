## Polarized NixOS Configuration

rebuild for `rick`

```
sudo nixos-rebuild --flake .#rick switch
```

test it out in vm

```
nix build .#nixosConfigurations.rick.config.system.build.vm --impure
./result/bin/run-*-vm
```
