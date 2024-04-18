{ pkgs, ... }:

{
  imports = [
    ./browser
    ./desktop-env
    ./shell
    ./chatting.nix
    ./coding.nix
    ./flatpak.nix
    ./fonts.nix
    ./games.nix
    ./keybase.nix
    ./libvirt.nix
    ./media.nix
    ./music.nix
    ./networking.nix
    ./nix-alien.nix
    ./printing.nix
    ./sound.nix
    ./wooting.nix
    ./work.nix
    ./yubikey.nix
  ];

  environment.systemPackages = with pkgs; [
    nano
    wget
    curl
    git
    openssl

    neofetch
    htop

    # provides a default authentification client for policykit
    lxqt.lxqt-policykit
  ];

  hardware.opentabletdriver.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
}
