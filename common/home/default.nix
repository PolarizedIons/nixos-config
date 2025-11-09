{ config, pkgs, user, setup, inputs, system, ... }:

{
  programs.home-manager.enable = true;
  home.username = user.login;
  home.homeDirectory = "/home/${user.login}";
  home.sessionPath = [ "/home/${user.login}/.bin" ];

  home.stateVersion = "23.11";

  _module.args.user = user;
  _module.args.setup = setup;
  _module.args.inputs = inputs;
  _module.args.system = system;
  imports = [
    ./desktop-env
    ./shell
    ./styling
    ./git.nix
    ./discord.nix
    ./obs.nix
    ./vr.nix
  ];
}
