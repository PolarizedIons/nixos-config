{ ... }:

{
  flake.nixosModules.printing = { pkgs, ... }: {
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      gutenprint
      pantum-driver
    ];
  };
}
