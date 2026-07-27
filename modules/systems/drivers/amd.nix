{
  config,
  ...
}:
{
  flake.nixosModules.amd-drivers =
    {
      ...
    }:
    {
      hardware = {
        amdgpu = {
          initrd.enable = true;
        };
      };

      programs.corectrl.enable = true;
      users.users."${config.username}".extraGroups = [ "corectrl" ];
    };
}
