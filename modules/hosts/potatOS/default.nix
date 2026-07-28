{ self, inputs, ... }:

{
  flake.nixosConfigurations.aegis = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      potatOS
      steamdeck
    ];
  };
}
