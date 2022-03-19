{ pkgs, ...}: 
{
    fonts.fonts = with pkgs; [
        ubuntu_font_family
        powerline-fonts
        noto-fonts-emoji
        unifont    
    ];
}
