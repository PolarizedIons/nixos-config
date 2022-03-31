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

      shellInit = ''
        PATH="$PATH:/home/polarizedions/.dotnet/tools"
      '';
    };
  };
}
