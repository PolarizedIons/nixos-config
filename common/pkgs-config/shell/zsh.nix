{ pkgs, ... }:

{
  users.users.polarizedions.shell = pkgs.zsh;
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
  environment.sessionVariables = rec {
    DOTNET_ROOT = "$(dirname $(realpath $(which dotnet)))";
    PATH = "$PATH:/home/polarizedions/.dotnet/tools";
  };
}
