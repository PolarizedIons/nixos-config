{ inputs, ... }:

{
  flake.nixosModules.teraflops = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      inputs.teraflops.packages."${pkgs.stdenv.hostPlatform.system}".default
      colmena
      hcloud
      packer
      terraform
    ];
  };
}
