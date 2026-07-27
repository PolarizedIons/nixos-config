{ ... }:

{

  flake.nixosModules.boot-loader = { ... }: {
    boot = {
      loader = {
        timeout = 3;
      };

      supportedFilesystems = [ "ntfs" ];
    };
  };
}
