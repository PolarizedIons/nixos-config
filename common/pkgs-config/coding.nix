{ lib, pkgs, config, unstable, ... }:
with lib; {
  config = mkIf config.setup.coding.enable {
    environment.systemPackages = with pkgs; [
      # IDEs
      vscode
      unstable.jetbrains.rider
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains.datagrip

      # Node
      nodejs
      yarn

      # Dotnet
      dotnet-sdk_7
      dotnet-aspnetcore_7

      # utils
      nixfmt
      pre-commit

      # k8s
      k9s
      kubectl
      fluxcd
      terraform
      openlens
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
