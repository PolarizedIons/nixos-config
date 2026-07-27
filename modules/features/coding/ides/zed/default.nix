{ self, ... }:

{
  flake.nixosModules.zed = { pkgs, ... }: {
    environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
      zed
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.zed = pkgs.zed-editor-fhs;
  };
}
