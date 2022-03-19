{ machine-name, pkgs, config, unstable, is-laptop }: 
{

imports = [
  ./fonts.nix
  ./user.nix
  # ./theming/theme.nix
  ./pkgs-config/desktop-env/setup.nix
  ./pkgs-config/shell/zsh.nix
  ./pkgs-config/chatting.nix
  (import ./pkgs-config/coding/setup.nix {inherit pkgs unstable;})
  ./pkgs-config/games.nix
  ./pkgs-config/keybase.nix
  ./pkgs-config/music.nix
];

environment.pathsToLink = [ "/libexec" ];
   

 nixpkgs.overlays = [
     (import ../overlays/polybar.nix)
];

  networking.hostName = machine-name;
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
    firefox
    neofetch
    htop
    pavucontrol
    xclip
   ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;
}
