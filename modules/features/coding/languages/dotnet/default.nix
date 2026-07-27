{ self, ... }:

{
  flake.nixosModules.dotnet = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      dotnet
    ];

    environment.sessionVariables = {
      DOTNET_ROOT = "${self.packages."${pkgs.stdenv.hostPlatform.system}".dotnet}";
    };
  };

  perSystem =
    { pkgs, ... }:
    let
      # https://discourse.nixos.org/t/dotnet-maui-workload/20370/10
      dotnet-combined =
        (
          with pkgs.dotnetCorePackages;
          combinePackages [
            sdk_10_0
            aspnetcore_10_0

            sdk_8_0
            aspnetcore_8_0
          ]
        ).overrideAttrs
          (
            finalAttrs: previousAttrs: {
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
            }
          );
    in
    {
      packages.dotnet = dotnet-combined;
    };
}
