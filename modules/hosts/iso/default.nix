{ self, inputs, ... }:

{
  flake.nixosConfigurations.iso = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      iso
      desktop
    ];
  };
}
