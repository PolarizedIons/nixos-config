{ pkgs, ... }: {
  services.printing.enable = false;
  services.printing.drivers = [ pkgs.gutenprint pkgs.pantum-driver ];
}
