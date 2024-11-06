{ lib, config, pkgs, ... }: {

  config = lib.mkIf config.setup.wooting.enable {
    hardware.wooting.enable = true;

    environment.systemPackages = with pkgs; [ wootility ];

    users.users = builtins.listToAttrs (builtins.map (u: {
      name = u.login;
      value = { extraGroups = [ "input" ]; };
    }) config.setup.users);
  };
}
