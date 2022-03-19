{ pkgs, unstable, ... }: 
{
    environment.systemPackages = [
        unstable.jetbrains.rider
        # jetbrains.rider
    ];
}
