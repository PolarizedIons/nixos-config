{ lib, pkgs, config, unstable, ... }: {
  imports = [ ./setup.nix ./user.nix ./config ];

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

  # what is requiring this???!
  nixpkgs.config.permittedInsecurePackages =
    [ "electron-24.8.6" "electron-25.9.0" ];

}
