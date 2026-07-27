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
      ];
    in
    {
      imports = modules;

      powerManagement.cpuFreqGovernor = "performance";
    }
  );
}
