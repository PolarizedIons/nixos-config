{pkgs, ...}: 
{
    environment.systemPackages = with pkgs; [
    minecraft
steam
    ];
}