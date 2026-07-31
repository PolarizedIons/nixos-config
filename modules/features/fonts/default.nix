{ ... }:

{
  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
        ubuntu-classic
        powerline-fonts
        noto-fonts-color-emoji
        unifont
        corefonts
        vista-fonts
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.fira-mono
      ];
    };
  };
}
