{pkgs, ...}: 
{
    environment.systemPackages = with pkgs; [
        minecraft
    ];
    programs.steam.enable = true;
}