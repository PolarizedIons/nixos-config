{
  self,
  moduleWithSystem,
  ...
}:

{
  flake.nixosModules.internet = moduleWithSystem (
    { ... }:
    let
      modules = with self.nixosModules; [
        chromium
        zen
      ];
    in
    {
      imports = modules;
    }
  );
}
