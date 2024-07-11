{ pkgs, ... }: {
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.pantum-driver ];
}
