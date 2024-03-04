{ pkgs, lib, config, ... }:

{
  programs.zsh.enable = true;

  users.users = builtins.listToAttrs (builtins.map (user: {
    name = user.login;
    value = { shell = pkgs.zsh; };
  }) (builtins.filter (u: u.shell == "zsh") config.setup.users));
}
