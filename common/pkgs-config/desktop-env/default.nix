{ pkgs, ... }:

{
  imports = [ ./xserver.nix ./gnome.nix ./dbus.nix ];
}
