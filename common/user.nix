{ config, ... }:

{
  users.users = builtins.listToAttrs (builtins.map (u: {
    name = u;
    value = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "dialout" ];
    };
  }) config.setup.users);

}
