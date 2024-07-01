{ pkgs, ... }: {
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.gutenprint
    # Temp: broken package
    # pkgs.pantum-driver 
  ];
}
