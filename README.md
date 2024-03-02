## Polarized NixOS Configuration

rebuild for `rick`

```
nixos-rebuild --flake .#rick switch
```

test it out in vm

```
nix-build '<nixpkgs/nixos>' -A vm --arg configuration ./configuration.nix
./result/bin/run-*-vm
```
