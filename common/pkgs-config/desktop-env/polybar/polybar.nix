{ pkgs }:
let
  colors = import ../../../theming/colors.nix;

  config = import ./polybar-conf.nix { inherit colors; };
  config-file = pkgs.writeTextFile {
    name = "polybar-config";
    text = config;
  };
in pkgs.writeScript "polybar-with-config" ''
  ${pkgs.polybar}/bin/polybar-msg cmd quit; ${pkgs.coreutils}/bin/env ${pkgs.polybar}/bin/polybar -c "${config-file}" $@''
