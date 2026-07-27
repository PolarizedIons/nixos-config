{ config, ... }:

{

  flake.nixosModules.docker = { ... }: {
    virtualisation.docker.enable = true;
    users.users."${config.username}".extraGroups = [ "docker" ];
  };
}
