{ inputs, system, config, ... }:

let
  nonWorkMode = !config.setup.work-mode.enable;
  services = {
    sudo = true;
    login = nonWorkMode;
    kde = nonWorkMode;
    sddm = nonWorkMode;
    polkit-1 = nonWorkMode;
  };
in {
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
}
