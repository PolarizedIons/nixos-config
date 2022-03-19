{pkgs, unstable, ...}: 
{
imports = [
  ./dotnet/dotnet.nix
  (import ./dotnet/rider.nix { inherit pkgs unstable; })
  ./nodejs.nix
];

    environment.systemPackages = with pkgs; [

    vscode
    
    
  ];
}
