{
  self,
  moduleWithSystem,
  ...
}:

{
  flake.nixosModules.laptop = moduleWithSystem (
    { ... }:
    let
      modules = with self.nixosModules; [
        core
        wifi
        bluetooth
        touchpad
        alacritty
        shared
        sddm
        niri
        noctalia
        fuzzel
      ];
    in
    {
      imports = modules;
    }
  );
}
