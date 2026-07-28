{ self, inputs, ... }:

{
  flake.nixosConfigurations.potatOS = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      potatOS
      steamdeck
    ];
  };
}
