{ ... }:

{
  flake.nixosModules.screen-recording = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ gpu-screen-recorder-gtk ];

    # For promptless recording on both CLI and GUI
    programs.gpu-screen-recorder.enable = true;
  };
}
