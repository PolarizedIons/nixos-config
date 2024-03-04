{ pkgs, lib, user, ... }:

{
  config = lib.mkIf (user.shell == "zsh") {

    services.gpg-agent.enableZshIntegration = true;

    programs = {
      zsh = {
        enable = true;
        enableAutosuggestions = true;
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
