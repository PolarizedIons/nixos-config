{ self, config, ... }:

{

  flake.nixosModules.zsh =
    { pkgs, ... }:
    {
      imports = [ self.nixosModules.shell-core ];

      # services.gpg-agent.enableZshIntegration = true;
      programs.direnv.enableZshIntegration = true;

      users.users."${config.username}".shell = pkgs.zsh;

      programs = {
        zsh = {
          enable = true;
          autosuggestions.enable = true;
          enableCompletion = true;
          syntaxHighlighting.enable = true;
          enableLsColors = true;

          interactiveShellInit = ''
            source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
          '';

          shellAliases = {
            ls = "${pkgs.eza}/bin/eza --icons --grid --classify --colour=auto --sort=type --group-directories-first --header --modified --created --git --binary --group";
            cat = "${pkgs.bat}/bin/bat";
          };

          # plugins = [
          #   {
          #     name = "powerlevel10k-config";
          #     src = ./config;
          #     file = "p10k.zsh";
          #   }
          #   {
          #     name = "zsh-powerlevel10k";
          #     src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
          #     file = "powerlevel10k.zsh-theme";
          #   }
          # ];
        };
      };
    };
}
