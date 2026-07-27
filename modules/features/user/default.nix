{ config, ... }:

{
  flake.nixosModules.user = { ... }: {
    users.users."${config.username}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
  };
}
