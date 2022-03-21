{ pkgs }:
let
  colors = import ../../../theming/colors.nix;

  config = import ./polybar-conf.nix { inherit colors; };
  config-file = pkgs.writeTextFile {
    name = "polybar-config";
    text = config;
  };
in 
pkgs.writeScript "polybar-with-config" ''
  ${pkgs.polybar}/bin/polybar-msg cmd quit;
  if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
      echo "Starting on monitor $m"
      MONITOR=$m ${pkgs.polybar}/bin/polybar --reload -c "${config-file}" $@ &
    done
  else
    ${pkgs.polybar}/bin/polybar --reload -c "${config-file}" $@
  fi
''
