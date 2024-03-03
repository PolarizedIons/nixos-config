{ pkgs, lib, config, ... }:

{
  config = lib.mkIf (config.setup.shell == "zsh") {
    users.users = builtins.listToAttrs (builtins.map (u: {
      name = u;
      value = { shell = pkgs.zsh; };
    }) config.setup.users);

    programs = {
      zsh = {
        enable = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;

        ohMyZsh = {
          enable = true;
          plugins = [ "git" "sudo" ];
          theme = "agnoster";
        };
      };
    };
  };
}
