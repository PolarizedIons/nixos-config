{ ... }:

{
  flake.nixosModules.git = { ... }: {
    programs.git = {
      enable = true;
      lfs.enable = true;
      config = {
        init = {
          defaultBranch = "main";
        };
        user = {
          name = "polarizedions";
          email = "me@polarizedions.net";
        };
      };
    };
  };
}
