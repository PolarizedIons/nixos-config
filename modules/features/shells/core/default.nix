{ ... }:

{

  flake.nixosModules.shell-core = { ... }: {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    # disable built-in command-not-found, which doesn't work with flakes
    programs.command-not-found.enable = false;
  };
}
