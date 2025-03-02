{ inputs, system, config, lib, ... }:

let
  enable = config.setup.pam-beacon.enable;
  nonWorkMode = !config.setup.work-mode.enable;
  services = {
    sudo = true;
    login = nonWorkMode;
    kde = nonWorkMode;
    sddm = nonWorkMode;
    polkit-1 = nonWorkMode;
    hyprlock = nonWorkMode;
  };
in {
  config = lib.mkIf enable {
    security.pam.services = builtins.mapAttrs (name: value: {
      rules.auth = {
        pambeacon = {
          enable = value;
          control = "sufficient";
          modulePath = "${
              inputs.pam-beacon-rs.packages.${system}.pam-beacon-rs
            }/lib/libpambeaconrs.so";
          order = 1;
        };
      };
    }) services;
  };
}
