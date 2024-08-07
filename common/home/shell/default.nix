{ config, lib, ... }:

let
  all = lib.filterAttrs (n: _: n != "default.nix" && !lib.hasPrefix "." n)
    (builtins.readDir ./.);

in {
  imports = map (p: ./. + "/${p}") (builtins.attrNames all);

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
