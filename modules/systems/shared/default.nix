{
  self,
  moduleWithSystem,
  ...
}:

{
  flake.nixosModules.shared = moduleWithSystem (
    { ... }:
    let
      modules = with self.nixosModules; [
        avahi
        boot-loader
        internet
        core
        core-drivers
        discord
        fonts
        fwupd
        gimp
        git
        kernel
        localisation
        networking
        nix-config
        nix-alien
        plymouth
        power
        printing
        shell-core
        sound
        spotify
        stylix
        sudo
        tailscale
        user
        yubikey
        niri
        noctalia
        sddm
        otter-launcher
        zsh
      ];
    in
    {
      imports = modules;
    }
  );
}
