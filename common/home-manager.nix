{ inputs, system, config, pkgs, ... }@args:
let setup = config.setup;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";

      home-manager.users = builtins.listToAttrs (builtins.map (user: {
        name = user.login;
        value = import ./home (args // { inherit user setup inputs system; });
      }) config.setup.users);
    }
  ];
}
