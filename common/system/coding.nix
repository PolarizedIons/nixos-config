{ lib, pkgs, config, inputs, system, ... }:
let
  # https://discourse.nixos.org/t/dotnet-maui-workload/20370/10
  dotnet-combined = (with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_10_0
      aspnetcore_10_0

      sdk_8_0
      aspnetcore_8_0
    ]).overrideAttrs (finalAttrs: previousAttrs: {
      # This is needed to install workload in $HOME
      # https://discourse.nixos.org/t/dotnet-maui-workload/20370/2

      postBuild = (previousAttrs.postBuild or "") + ''
        for i in $out/sdk/*
        do
          i=$(basename $i)
          mkdir -p $out/metadata/workloads/''${i/-*}
          touch $out/metadata/workloads/''${i/-*}/userlocal
        done
      '';
    });
in with lib; {
  config = mkIf config.setup.coding.enable {
    environment.systemPackages = with pkgs; [
      # IDEs
      vscode
      jetbrains.rider
      jetbrains.datagrip
      jetbrains.phpstorm
      jetbrains.clion
      # jetbrains.fleet

      # Node
      nodejs
      nodePackages_latest.pnpm

      # Dotnet
      dotnet-combined

      # python
      python3

      # php
      # php
      # laravel
      # php83Packages.composer

      # utils
      nixfmt-classic
      pre-commit
      ldns
      xdg-utils
      jq
      # terraform

      # k8s
      # k9s
      # kubectl
      # fluxcd
      # lens
      # kubernetes-helm

      # other
      # python311Packages.pyngrok

      # inputs.teraflops.packages.${system}.default
      # colmena
      # hcloud
      # packer

      # ghostty
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
      DOTNET_ROOT = "${dotnet-combined}";
      PATH = "$PATH:" + (concatStringsSep ":"
        (builtins.map (u: "/home/${u.login}/.dotnet/tools")
          config.setup.users));
    };
  };
}
