{ pkgs, lib, user, config, ... }:

{
  config = lib.mkIf (user.shell == "zsh") {
    services.gpg-agent.enableZshIntegration = true;

    programs.direnv.enableZshIntegration = true;

    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          ls =
            "${pkgs.eza}/bin/eza --icons --grid --classify --colour=auto --sort=type --group-directories-first --header --modified --created --git --binary --group";
          cat = "${pkgs.bat}/bin/bat";
        };

        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "sudo" ];
          theme = "agnoster";
        };
      };
    };
  };
}
