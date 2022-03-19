{ pkgs, ...}: 

let 
dotnetCombined = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_5_0
        sdk_6_0
        aspnetcore_5_0
        aspnetcore_6_0
    ];
in
{
    environment.systemPackages = [
        dotnetCombined
    ];
}
