{ moduleWithSystem, self, ... }:

{
  flake.nixosModules.development = moduleWithSystem (
    { ... }: {
      imports = with self.nixosModules; [
        agenix
        docker
        git

        rider
        zed
        dotnet
        javascript
        nix
        python
      ];
    }
  );
}
