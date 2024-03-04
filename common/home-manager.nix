{ inputs, config, pkgs, ... }@args:
let setup = config.setup;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.users = builtins.listToAttrs (builtins.map (user: {
        name = user.login;
        value = import ./home (args // { inherit user setup; });
      }) config.setup.users);
    }
  ];
}
