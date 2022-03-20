{ lib, pkgs, config, unstable, ... }:
with lib;
let
  dotnetCombined = with pkgs.dotnetCorePackages;
    combinePackages [ sdk_5_0 sdk_6_0 aspnetcore_5_0 aspnetcore_6_0 ];
in {
  config = mkIf config.setup.coding.enable {
    environment.systemPackages = with pkgs; [
      # IDEs
      vscode
      unstable.jetbrains.rider

      # Node
      nodejs
      yarn

      # Dotnet
      dotnetCombined
    ];
  };
}
