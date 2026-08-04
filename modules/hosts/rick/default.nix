{ self, inputs, ... }:

{
  flake.nixosConfigurations.rick = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      rick
      laptop
      amd-drivers
      coding-utils
      zed
      gaming
    ];
  };
}
