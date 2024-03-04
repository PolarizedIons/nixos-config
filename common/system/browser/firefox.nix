{ pkgs, config, lib, ... }: {
  config = lib.mkIf ((builtins.elem "firefox" config.setup.browsers)) {
    environment.systemPackages = with pkgs; [ firefox ];
  };
}
