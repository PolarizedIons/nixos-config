{ pkgs, ... }: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      ubuntu-classic
      powerline-fonts
      noto-fonts-color-emoji
      unifont
      corefonts
      vista-fonts
      jetbrains-mono
      nerd-fonts.jetbrains-mono
    ];
  };
}
