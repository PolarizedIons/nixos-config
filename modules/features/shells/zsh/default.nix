{
  inputs,
  config,
  self,
  ...
}:

{
  flake.nixosModules.zsh =
    { pkgs, ... }:
    {
      imports = [ self.nixosModules.shell-core ];

      programs.direnv.enableZshIntegration = true;

      users.users."${config.username}".shell = self.packages."${pkgs.stdenv.hostPlatform.system}".zsh;
    };

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.zsh = inputs.wrappers.wrappers.zsh.wrap {
        inherit pkgs;

        install.enable = true;
        install.asSystemDefault = true;

        zshAliases = {
          ls = "${pkgs.eza}/bin/eza --icons --grid --classify --colour=auto --sort=type --group-directories-first --header --modified --created --git --binary --group";
          cat = "${pkgs.bat}/bin/bat";
        };

        zshrc.path = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/moarram/headline/main/headline.zsh-theme";
          hash = "sha256-lxnLei7zi1sErvPXtTAObvcJUsXtpVxVZWQdZYMnFcU=";
        };

        zshrc.content = ''
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          # ^ syntax-highlighting must be sourced LAST, after any other widget-wrapping plugins

          # Autocomplete
          autoload -Uz compinit
          compinit

          # ls-colors
          zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

          # Command not found script for flakes
          source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh

          # Ctrl + Left
          bindkey "^[[1;5D" backward-word
          # Ctrl + right
          bindkey "^[[1;5C" forward-word
          # Up
          bindkey '^[[A' history-beginning-search-backward
          # Down
          bindkey '^[[B' history-beginning-search-forward
          # Home
          bindkey  "^[[H"   beginning-of-line
          # End
          bindkey  "^[[F"   end-of-line
          # Delete
          bindkey  "^[[3~"  delete-char

          # History
          HISTFILE="$HOME/.zsh_history"
          HISTSIZE=50000
          SAVEHIST=50000
          setopt EXTENDED_HISTORY
          setopt INC_APPEND_HISTORY
          setopt SHARE_HISTORY
          setopt HIST_IGNORE_DUPS
          setopt HIST_IGNORE_SPACE

          # Settings for prompt
          HL_SEP_MODE='on'
          HL_INFO_MODE='auto'
          HL_OVERWRITE='on'
          HL_SEP=(
            _PRE  '┍' # consider '┌' or '╭'
            _LINE '━' # consider '─'
            _POST '┑' # consider '┐' or '╮'
          )
          HL_LAYOUT_STYLE="%{$light_black%}"
          HL_LAYOUT_TEMPLATE=(
            _PRE    "│''${IS_SSH+ %{$reset$faint%\}ssh}" # shows " ssh" if this is an SSH session
            USER    ' ...'
            HOST    " %{$reset$faint%}at%{$reset$HL_LAYOUT_STYLE%} ..."
            VENV    " %{$reset$faint%}with%{$reset$HL_LAYOUT_STYLE%} ..."
            PATH    " %{$reset$faint%}in%{$reset$HL_LAYOUT_STYLE%} ..."
            _SPACER '''
            BRANCH  " %{$reset$faint%}on%{$reset$HL_LAYOUT_STYLE%} ..."
            STATUS  ' ...'
            _POST   ' │'
          )
          HL_LAYOUT_FIRST=(
            HOST    ' ...'
            VENV    ' ...'
            PATH    ' ...'
            _SPACER ' '
            BRANCH  ' ...'
          )
          HL_CONTENT_TEMPLATE=(
            USER   "%{$bold$red%} ..."
            HOST   "%{$bold$yellow%} ..."
            VENV   "%{$bold$green%} ..."
            PATH   "%{$bold$blue%} ..."
            BRANCH "%{$bold$cyan%} ..."
            STATUS "%{$bold$magenta%}..."
          )
          HL_GIT_SEP_SYMBOL='''
          HL_GIT_STATUS_SYMBOLS[CONFLICTS]="%{$red%}✘"
          HL_GIT_STATUS_SYMBOLS[CLEAN]="%{$green%}✔"
          HL_PROMPT="%{$HL_LAYOUT_STYLE%}╯ %{$reset%}$ "
          HL_CLOCK_MODE='on'
          HL_CLOCK_TEMPLATE="%{$faint%} ... %{$reset$HL_LAYOUT_STYLE%}╰"
          HL_ERR_MODE='on'
        '';
      };
    };
}
