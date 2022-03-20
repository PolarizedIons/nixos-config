{ terminal, rofi, pkgs, config, wallpaper, polybar }:

let colors = import ../../../theming/colors.nix;

in with colors; ''
  for_window [class=".*"] border pixel 0
  gaps inner 10
  smart_gaps on

  set $workspace1 1
  set $workspace2 2
  set $workspace3 3
  set $workspace4 4
  set $workspace5 5
  set $workspace6 6
  set $workspace7 7
  set $workspace8 8
  set $workspace9 9
  set $workspace10 10
  font pango:Ubuntu 8
  # class                 container-border    container-backgr  text          indicator   window-border
  client.focused          ${mlight}           ${mlight}         ${dark}       ${accent}   ${mlight}
  client.focused_inactive ${mdark}            ${mdark}          ${light}      ${accent}   ${mdark}
  client.unfocused        ${dark}             ${mdark2}         ${mlight}     ${accent}   ${mdark2}
  client.urgent           ${accent}           ${dark}           ${light}      ${dark}     ${accent}
  client.placeholder      ${mdark}            ${mdark}          ${light}      ${accent}   ${mdark}
  client.background       ${light}

  exec --no-startup-id ${pkgs.feh}/bin/feh --bg-fill ${wallpaper}
  exec --no-startup-id ${polybar} mybar
  ${if config.setup.chatting.enable then
    "exec --no-startup-id ${pkgs.discord}/bin/discord"
  else
    ""}

  ${import ./i3-keys.nix { inherit pkgs config terminal rofi; }}
''
