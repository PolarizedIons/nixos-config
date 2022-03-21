{ lib, terminal, rofi, pkgs, config, wallpaper, polybar }:

let colors = import ../../../theming/colors.nix;
    # consts
    workspaces = 10;
    monitors = config.setup.monitors;
    monitor-count = count monitors;

    # helper functions
    elemAt = builtins.elemAt;
    count = x: (lib.lists.count (y: true) x);
    mod = lib.trivial.mod;
    toStr = builtins.toString;
    set-workspace = i: "set $workspace${toStr i} ${toStr i}\n";
    out-workspace = i: "workspace $workspace${toStr i} output ${toStr (gen-monitor-at i)}\n";

    # generators
    gen-monitor-at = i: elemAt monitors (mod (i - 1) monitor-count);
    gen-workspaces = i: if i < workspaces then (set-workspace i) + gen-workspaces (i + 1) else set-workspace i;
    gen-outputs = i: if monitor-count == 0 then "" else (if i < workspaces then (out-workspace i) + gen-outputs (i + 1) else out-workspace i);    

in with colors; ''
  for_window [class=".*"] border pixel 0
  gaps inner 10
  smart_gaps on

${gen-workspaces 1}

${gen-outputs 1}


#  font pango:Ubuntu 8
  # class                 container-border    container-backgr  text          indicator   window-border
  client.focused          ${mlight}           ${mlight}         ${dark}       ${accent}   ${mlight}
  client.focused_inactive ${mdark}            ${mdark}          ${light}      ${accent}   ${mdark}
  client.unfocused        ${dark}             ${mdark2}         ${mlight}     ${accent}   ${mdark2}
  client.urgent           ${accent}           ${dark}           ${light}      ${dark}     ${accent}
  client.placeholder      ${mdark}            ${mdark}          ${light}      ${accent}   ${mdark}
  client.background       ${light}

  exec --no-startup-id ${pkgs.feh}/bin/feh --bg-fill ${wallpaper}
  exec --no-startup-id ${polybar} mybar
  bindsym $mod+Shift+p exec ${polybar} mybar

  ${if config.setup.chatting.enable then
    "exec --no-startup-id ${pkgs.discord}/bin/discord"
  else
    ""}

  ${import ./i3-keys.nix { inherit pkgs config terminal rofi; }}
''
