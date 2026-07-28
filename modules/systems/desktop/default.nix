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
        shared
        agenix
        alacritty
        development
        docker
        gaming
        obs
        screen-recording
        virtualisation
        sddm
        niri
        noctalia
        fuzzel
      ];
    in
    {
      imports = modules;

      powerManagement.cpuFreqGovernor = "performance";
    }
  );
}
