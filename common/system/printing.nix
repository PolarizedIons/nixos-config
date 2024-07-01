{ pkgs, ... }: {
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    # Temp: broken package: https://github.com/NixOS/nixpkgs/pull/321089
    # pkgs.pantum-driver 
  ];
}
