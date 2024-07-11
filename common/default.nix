{ lib, pkgs, config, ... }: {
  imports = [ ./setup.nix ./user.nix ./system ./home-manager.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = config.setup.machine-name;

  boot.supportedFilesystems = [ "ntfs" ];
  time.timeZone = config.setup.timezone;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.pathsToLink = [ "/libexec" ];

  # Automount removable drives
  services.gvfs.enable = true;

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;

  hardware.enableAllFirmware = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # TODO: figure out what is requireing this
  nixpkgs.config.permittedInsecurePackages =
    [ "python3.12-youtube-dl-2021.12.17" ];
}
