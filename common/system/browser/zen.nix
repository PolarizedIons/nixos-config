{ pkgs, config, lib, inputs, system, ... }: {
  config = lib.mkIf ((builtins.elem "zen" config.setup.browsers)) {
    environment.systemPackages = with pkgs;
      [ inputs.zen-browser.packages.${system}.default ];
  };
}
