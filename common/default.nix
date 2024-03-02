{ lib, pkgs, config, unstable, ... }:
let homeCA = pkgs.copyPathToStore ./PolarizedHomeCA.pem;
in {
  imports = [
    ./setup.nix
    ./fonts.nix
    ./user.nix
    ./libvirt.nix
    ./pkgs-config/desktop-env
    ./pkgs-config/shell/zsh.nix
    ./pkgs-config/chatting.nix
    ./pkgs-config/coding.nix
    ./pkgs-config/games.nix
    ./pkgs-config/keybase.nix
    ./pkgs-config/music.nix
    ./nix-alien.nix
    ./yubikey.nix
  ];

  services.flatpak.enable = true;

  environment.pathsToLink = [ "/libexec" ];

  nixpkgs.overlays = [ (import ../overlays/discord.nix) ];

  networking.hostName = config.setup.machine-name;

  boot.supportedFilesystems = [ "ntfs" ];

  networking.nameservers = [ "192.168.0.15" "1.1.1.1" "8.8.8.8" ];
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

    # whiteboard
    lorien

    # notes
    obsidian

    # provides a default authentification client for policykit
    lxqt.lxqt-policykit

    # casting
    mkchromecast
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

  # mDNS
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # what is requiring this???!
  nixpkgs.config.permittedInsecurePackages =
    [ "electron-24.8.6" "electron-25.9.0" ];

  services.udev.extraRules = ''
    # Wooting One Legacy

    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

    # Wooting One update mode

    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess"

    # Wooting Two Legacy

    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

    # Wooting Two update mode

    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess"

    # Generic Wootings

    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", TAG+="uaccess"

    SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", TAG+="uaccess"
  '';

}
