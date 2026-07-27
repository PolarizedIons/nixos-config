{
  self,
  moduleWithSystem,
  ...
}:

{
  flake.nixosModules.gaming = moduleWithSystem (
    { ... }:
    let
      modules = with self.nixosModules; [
        game-accessories
        minecraft
        steam
      ];
    in
    {
      imports = modules;
    }
  );
}
