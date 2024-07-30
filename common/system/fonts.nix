{ pkgs, ... }: {
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      ubuntu_font_family
      powerline-fonts
      noto-fonts-emoji
      unifont
      corefonts
      vistafonts
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
}
