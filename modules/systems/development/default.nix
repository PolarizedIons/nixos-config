{ moduleWithSystem, self, ... }:

{
  flake.nixosModules.development = moduleWithSystem (
    { ... }: {
      imports = with self.nixosModules; [
        coding-utils
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
