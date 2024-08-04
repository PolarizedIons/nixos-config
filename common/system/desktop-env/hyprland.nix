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
      swaynotificationcenter # notification daemon
      libnotify
      rofi-wayland # program opener
      networkmanagerapplet # network applet in toolbar

      hyprshot # screenshots
      hyprpaper # wallpapers

      pavucontrol # audio control

      kdePackages.kwallet
      kdePackages.kwalletmanager

      nemo
      ark
      clipman
      wl-clipboard
    ];

    services.blueman.enable = true;

    security.pam.services = {
      sddm.enableKwallet = true;
      login.enableKwallet = true;
    };
  };
}
