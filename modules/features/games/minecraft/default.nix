{ ... }:

{
  flake.nixosModules.minecraft = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      prismlauncher
    ];
  };
}
