{ self, inputs, ... }:

{
  flake.nixosConfigurations.aegis = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      aegis
      desktop
      amd-drivers
      wooting
      teraflops
      impermanence
      logitec-devices
      # vm-gpu
    ];
  };
}
