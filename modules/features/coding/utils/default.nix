{ ... }:

{
  flake.nixosModules.coding-utils = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      jq
    ];

    programs.mtr.enable = true;
  };
}
