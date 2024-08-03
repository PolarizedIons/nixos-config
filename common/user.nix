{ config, ... }:

{
  users.users = builtins.listToAttrs (builtins.map (u: {
    name = u.login;
    value = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "dialout" ];
    };
  }) config.setup.users);
}
