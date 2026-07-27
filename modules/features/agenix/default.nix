{
  inputs,
  self,
  ...
}:

{

  flake.nixosModules.agenix =
    {
      pkgs,
      ...
    }:
    {
      imports = [ inputs.agenix.nixosModules.default ];

      environment.systemPackages = with self.packages."${pkgs.stdenv.hostPlatform.system}"; [
        agenix
      ];
    };

  perSystem = { inputs', ... }: {
    packages.agenix = inputs'.agenix.packages.default;
  };
}
