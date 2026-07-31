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
        sudo
        tailscale
        user
        yubikey
        zsh
      ];
    in
    {
      imports = modules;
    }
  );
}
