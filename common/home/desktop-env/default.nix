{ pkgs, lib, config, ... }:

let all = lib.filterAttrs (n: _: n != "default.nix") (builtins.readDir ./.);

in { imports = map (p: ./. + "/${p}") (builtins.attrNames all); }
