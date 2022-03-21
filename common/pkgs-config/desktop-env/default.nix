{ pkgs, ... }:

{
  imports = [ ./xserver.nix ./i3/i3.nix ./dbus.nix ];
}
