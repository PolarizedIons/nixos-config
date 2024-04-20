{ inputs, system, ... }:

{
  security.pam.services.sudo.rules.auth = {
    pambeacon = {
      enable = true;
      control = "sufficient";
      modulePath = "${
          inputs.pam-beacon-rs.packages.${system}.pam-beacon-rs
        }/lib/libpambeaconrs.so";
      order = 1;
    };
  };
}
