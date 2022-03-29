{ lib, pkgs, config, ... }:
let
  unstable = import (builtins.fetchTarball
    "https://github.com/nixos/nixpkgs/tarball/9cd5fa4f853150b20f506fb2943a0898d1bb9442")
  # reuse the current configuration
    { config = config.nixpkgs.config; };
in {
  imports = [
    ./setup.nix
    ./fonts.nix
    ./user.nix
    ./theming/theme.nix
    ./pkgs-config/desktop-env
    ./pkgs-config/shell/zsh.nix
    ./pkgs-config/chatting.nix
    (import ./pkgs-config/coding.nix { inherit lib pkgs config unstable; })
    ./pkgs-config/games.nix
    ./pkgs-config/keybase.nix
    ./pkgs-config/music.nix
  ];

  environment.pathsToLink = [ "/libexec" ];

  nixpkgs.overlays = [ (import ../overlays/polybar.nix) ];

  networking.hostName = config.setup.machine-name;
  networking.nameservers = [ "192.168.0.30" "1.1.1.1" ];
  networking.networkmanager.enable = true;
  time.timeZone = "Africa/Johannesburg";

  networking.useDHCP = false;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    nano
    wget
    git

    firefox
    chromium

    neofetch
    htop
    pavucontrol
    xclip

    pcmanfm
    # provides a default authentification client for policykit
    lxqt.lxqt-policykit
  ];

  # Automount removable drives
  services.gvfs.enable = true;

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;
}
