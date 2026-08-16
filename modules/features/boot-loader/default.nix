{ ... }:

{

  flake.nixosModules.boot-loader = { ... }: {
    boot = {
      loader = {
        timeout = 3;
        systemd-boot.configurationLimit = 5;
      };

      supportedFilesystems = [ "ntfs" ];
    };
  };
}
