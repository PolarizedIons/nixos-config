{ pkgs, config, lib, inputs, system, ... }:
let hypr-nixpkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
in {
  imports = [ inputs.hyprland.nixosModules.default ];
  config = lib.mkIf (config.setup.desktop-environment == "hyprland") {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    programs.hyprlock.enable = true;
    # services.hypridle.enable = true;

    hardware.graphics = {
      enable = true;
      package = hypr-nixpkgs.mesa.drivers;

      # if you also want 32-bit support (e.g for Steam)
      enable32Bit = true;
      package32 = hypr-nixpkgs.pkgsi686Linux.mesa.drivers;
    };

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
