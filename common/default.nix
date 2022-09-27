{ lib, pkgs, config, ... }:
let
  homeCA = pkgs.copyPathToStore ./PolarizedHomeCA.pem;
  unstable = import (builtins.fetchTarball
    "https://github.com/nixos/nixpkgs/tarball/9f59caf45c315651d06bb3e6791b14485071e50e")
  # reuse the current configuration
    { config = config.nixpkgs.config; };
in {
  imports = [
    ./setup.nix
    ./fonts.nix
    ./user.nix
    ./libvirt.nix
    ./pkgs-config/desktop-env
    ./pkgs-config/shell/zsh.nix
    ./pkgs-config/chatting.nix
    (import ./pkgs-config/coding.nix { inherit lib pkgs config unstable; })
    ./pkgs-config/games.nix
    ./pkgs-config/keybase.nix
    ./pkgs-config/music.nix
  ];

  environment.pathsToLink = [ "/libexec" ];

  nixpkgs.overlays = [ (import ../overlays/discord.nix) ];

  networking.hostName = config.setup.machine-name;

  networking.nameservers = [ "192.168.0.30" "1.1.1.1" ];
  networking.resolvconf.enable = pkgs.lib.mkForce false;
  networking.dhcpcd.extraConfig = "nohook resolv.conf";
  networking.networkmanager.dns = "none";
  services.resolved.enable = false;

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
    openssl
    brightnessctl
    obs-studio
    vlc

    # provides a default authentification client for policykit
    lxqt.lxqt-policykit
  ];

  nixpkgs.config = { chromium = { enableWideVine = true; }; };

  security.pki.certificateFiles = [ homeCA ];

  # Automount removable drives
  services.gvfs.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.pantum-driver ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;
}
