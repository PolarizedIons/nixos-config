{ pkgs, lib, user, ... }:

{
  config = lib.mkIf (user.shell == "zsh") {

    services.gpg-agent.enableZshIntegration = true;

    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "sudo" ];
          theme = "agnoster";
        };
      };
    };
  };
}
