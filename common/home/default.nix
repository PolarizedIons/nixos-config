{ config, pkgs, user, setup, ... }:

{
  programs.home-manager.enable = true;
  home.username = user.login;
  home.homeDirectory = "/home/${user.login}";
  home.sessionPath = [ "/home/${user.login}/.bin" ];

  home.stateVersion = "23.11";

  _module.args.user = user;
  _module.args.setup = setup;
  imports = [ ./shell ./git.nix ./discord.nix ./obs.nix ];
}
