{ lib, pkgs, config, unstable, ... }:
with lib;
let
  dotnetCombined = with pkgs.dotnetCorePackages;
    combinePackages [ sdk_5_0 sdk_6_0 aspnetcore_5_0 aspnetcore_6_0 ];
in {
  config = mkIf config.setup.coding.enable {
    environment.systemPackages = with pkgs; [
      # IDEs
      vscode
      unstable.jetbrains.rider
      jetbrains.pycharm-professional
      jetbrains.datagrip

      # Node
      nodejs
      yarn

      # Dotnet
      dotnetCombined

      # utils
      nixfmt
      pre-commit

      # k8s
      lens
      k9s
      kubectl
      fluxcd
    ];

    virtualisation.docker.enable = true;
    users.users.polarizedions.extraGroups = [ "docker" ];

    system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
      mkdir -m 0755 -p /lib64
      ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
      mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
    '';
  };
}
