{ ... }:

{
  flake.nixosModules.sudo = { ... }: {
    security.sudo.extraConfig = ''
      Defaults	pwfeedback
    '';
  };
}
