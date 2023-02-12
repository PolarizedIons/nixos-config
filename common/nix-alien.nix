{ pkgs, ... }:

let
  nix-alien-pkgs = import (fetchTarball
    "https://github.com/thiagokokada/nix-alien/tarball/72fb114b9320db354f14533310819ea2a2d6b428")
    { };
in {
  environment.systemPackages = with nix-alien-pkgs; [
    nix-alien
    nix-index-update
    pkgs.nix-index # not necessary, but recommended
  ];

  # Optional, but this is needed for `nix-alien-ld` command
  programs.nix-ld.enable = true;
}
