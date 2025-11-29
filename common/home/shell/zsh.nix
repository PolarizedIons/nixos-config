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

        plugins = [
          {
            name = "powerlevel10k-config";
            src = ./.;
            file = ".p10k.zsh";
          }
          {
            name = "zsh-powerlevel10k";
            src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
            file = "powerlevel10k.zsh-theme";
          }
        ];
      };
    };
  };
}
