self: super:
{ polybar = super.polybar.override { i3GapsSupport = true; pulseSupport = true; }; }
