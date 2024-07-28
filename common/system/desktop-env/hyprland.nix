{ pkgs, config, lib, inputs, system, ... }:

{
  config = lib.mkIf (config.setup.desktop-environment == "hyprland") {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${system}.hyprland;
      xwayland.enable = true;
    };
    programs.hyprlock.enable = true;
    # services.hypridle.enable = true;

    hardware.graphics.enable = true;

    environment.systemPackages = with pkgs; [
      kitty # terminal
      libsForQt5.polkit-kde-agent
      dunst # notification daemon
      libnotify
      swww # wallpapers
      rofi-wayland # program opener
      networkmanagerapplet # network applet in toolbar
      hyprshot

      kdePackages.kwallet
    ];

    security.pam.services.login.enableKwallet = true;
  };
}
