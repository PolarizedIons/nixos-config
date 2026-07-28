{ ... }:

{

  flake.nixosModules.core = { pkgs, ... }: {
    # Hint electron apps to use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services.dbus.enable = true;

    services.openssh.enable = true;

    nixpkgs.config.allowUnfree = true;

    hardware.enableAllFirmware = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    hardware.graphics.enable = true;

    xdg.portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        kdePackages.xdg-desktop-portal-kde
        # xdg-desktop-portal-gtk
      ];
      wlr = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      ldns
      xdg-utils
      nano
      wget
      curl
      git
      openssl
      tmux
      fastfetch
      htop
      btop
      nix-index
    ];
  };

  perSystem = { inputs, system }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
}
