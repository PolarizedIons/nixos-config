{ lib, pkgs, config, ... }:
with lib; {
  config = mkIf config.setup.coding.enable {
    environment.systemPackages = with pkgs; [
      # IDEs
      vscode
      jetbrains.rider
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains.datagrip

      # Node
      nodejs
      nodePackages_latest.pnpm

      # Dotnet
      dotnet-sdk_8
      dotnet-aspnetcore_8

      # utils
      nixfmt
      pre-commit
      ldns
      xdg-utils
      jq

      # k8s
      k9s
      kubectl
      fluxcd
      openlens
      kubernetes-helm

      terraform
    ];

    virtualisation.docker.enable = true;
    users.users = builtins.listToAttrs (builtins.map (u: {
      name = u.login;
      value = { extraGroups = [ "docker" ]; };
    }) config.setup.users);

    system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
      mkdir -m 0755 -p /lib64
      ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
      mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
    '';

    environment.sessionVariables = rec {
      DOTNET_ROOT = "$(dirname $(realpath $(which dotnet)))";
      PATH = "$PATH:" + (concatStringsSep ":"
        (builtins.map (u: "/home/${u.login}/.dotnet/tools")
          config.setup.users));
    };
  };
}
