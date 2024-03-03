{ pkgs, config, lib, nixpkgs, ... }: {
  config = lib.mkIf (builtins.elem "chromium" config.setup.browsers) {
    environment.systemPackages = with pkgs; [ chromium ];
    nixpkgs.config = { chromium = { enableWideVine = true; }; };
  };
}
