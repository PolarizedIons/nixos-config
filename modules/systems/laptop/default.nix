{
  self,
  moduleWithSystem,
  ...
}:

{
  flake.nixosModules.desktop = moduleWithSystem (
    { ... }:
    let
      modules = with self.nixosModules; [
        core
        touchpad
        alacritty
      ];
    in
    {
      imports = modules;
    }
  );
}
