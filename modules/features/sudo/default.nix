{ ... }:

{
  flake.nixosModules.sudo = { ... }: {
    security.sudo.extraConfig = ''
      Defaults	pwfeedback
      Defaults lecture = never
    '';
  };
}
