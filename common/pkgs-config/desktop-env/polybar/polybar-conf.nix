{ colors }:
with colors; ''
  [bar/mybar]
  enable-ipc = true
  monitor = ''${env:MONITOR:}

  height = 38
  padding-right = 1

  background = ${mdark3}
  foreground = ${accent}

  font-0 = Ubuntu Mono:size=16;2
  font-1 = Noto Color Emoji:scale=10;2
  font-2 = Unifornt:size=16;2

  separator =•
  separator-padding = 1px

  modules-left = workspaces
  modules-center = title
  modules-right = ethernet wifi cpu memory battery date

  [module/workspaces]
  type = internal/i3

  show-urgent = true
  index-sort = true
  format = <label-state>

  label-unfocused = %index%
  label-unfocused-padding = 2
  label-visible = %index%
  label-visible-padding = 2

  label-focused = %index%
  label-focused-padding = 2
  label-focused-foreground = ${light}
  label-focused-background = ${mdark}

  label-urgent = %index%
  label-urgent-padding = 2
  label-urgent-foreground = ${light}
  label-urgent-background = ${dmagenta}

  [module/date]
  type = internal/date
  date = %Y-%m-%d% 
  time = %H:%M
  label = %date% %time%

  [module/battery]
  type = internal/battery
  full-at = 95

  format-full = 🔋 <label-full>
  format-charging = 🔋 <label-charging>
  format-discharging = 🔋 -<label-discharging>
  format-low = 🔋<label-low> <animation-low>

  ; Only applies if <animation-low> is used
  ; New in version 3.6.0
  animation-low-0 = !
  animation-low-1 = 
  animation-low-framerate = 200

  [module/cpu]
  type = internal/cpu
  format = 🧠 <label>

  [module/memory]
  type = internal/memory
  format = 📗 <label>
  format-warn = 📙 <label-warn>
  ; Seconds to sleep between updates
  ; Default: 1
  interval = 3

  [module/title]
  type = internal/xwindow
  label = [%title%]
  format-foreground = ${light}

  [module/ethernet]
  type = internal/network
  interface = enp2s0
  label-connected = 🖥️ %local_ip%
  label-disconnected = 

  [module/wifi]
  type = internal/network
  interface = wlp1s0

  label-connected = 📶 %local_ip%

  format-connected = <label-connected>
  format-disconnected = <label-disconnected>
  format-packetloss = <animation-packetloss> <label-connected>

  animation-packetloss-0 = ⚠
  animation-packetloss-0-foreground = #ffa64c
  animation-packetloss-1 = 📶
  animation-packetloss-1-foreground = #000000
  animation-packetloss-framerate = 500
''
