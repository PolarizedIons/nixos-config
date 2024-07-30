{ pkgs, config, lib, nixpkgs, ... }: {
  config =
    lib.mkIf (builtins.elem "google-chrome-stable" config.setup.browsers) {
      environment.systemPackages = with pkgs; [ google-chrome ];
    };
}
