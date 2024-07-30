{ pkgs, config, lib, inputs, system, ... }: {
  config = lib.mkIf (config.setup.desktop-environment == "plasma"
    || config.setup.desktop-environment == "hyprland") {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;

        # forcing Qt5 libs because of https://github.com/NixOS/nixpkgs/issues/292761
        package = lib.mkForce pkgs.libsForQt5.sddm;
        extraPackages =
          pkgs.lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];

        theme = "catppuccin-sddm-corners";
      };

      environment.systemPackages = with pkgs;
        [ inputs.sddm-catppuccin.packages.${system}.catppuccin-sddm-corners ];
    };
}
