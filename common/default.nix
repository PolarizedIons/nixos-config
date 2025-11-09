{ lib, pkgs, config, inputs, ... }: {
  imports = [
    inputs.agenix.nixosModules.default
    inputs.stylix.nixosModules.stylix
    ./setup.nix
    ./user.nix
    ./system
    ./home-manager.nix
  ];

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

  nixpkgs.config.permittedInsecurePackages = [
    # TODO: figure out what is requireing this
    "python3.13-youtube-dl-2021.12.17"
    # Work requirement
    "dotnet-sdk-6.0.428"
    "aspnetcore-runtime-6.0.36"
  ];
}
