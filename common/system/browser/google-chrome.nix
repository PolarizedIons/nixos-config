{ pkgs, config, lib, nixpkgs, ... }: {
  config = lib.mkIf (builtins.elem "google-chrome" config.setup.browsers) {
    environment.systemPackages = with pkgs; [ google-chrome ];
  };
}
