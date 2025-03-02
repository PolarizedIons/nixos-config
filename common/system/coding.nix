{ lib, pkgs, config, inputs, system, ... }:
with lib; {
  config = mkIf config.setup.coding.enable {
    environment.systemPackages = with pkgs; [
      # IDEs
      vscode
      jetbrains.rider
      jetbrains.datagrip
      jetbrains.phpstorm
      jetbrains.clion

      # Node
      nodejs
      nodePackages_latest.pnpm

      # Dotnet
      dotnet-sdk_8
      dotnet-aspnetcore_8

      #python
      python3

      # php
      php
      laravel
      php83Packages.composer

      # utils
      nixfmt-classic
      pre-commit
      ldns
      xdg-utils
      jq
      terraform

      # k8s
      k9s
      kubectl
      fluxcd
      lens
      kubernetes-helm

      # other
      inputs.teraflops.packages.${system}.default
      colmena
      hcloud
      packer

      ghostty
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
