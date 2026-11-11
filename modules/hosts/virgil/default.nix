{ self, inputs, ... }:

{
  flake.nixosConfigurations.virgil = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      virgil
      mac-drivers
      shared
      agenix
      alacritty
      development
      docker
      obs
      screen-recording
      sddm
      niri
      noctalia
      fuzzel
    ];
  };
}
