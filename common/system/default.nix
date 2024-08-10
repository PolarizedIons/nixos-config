{ pkgs, inputs, system, ... }:

{
  imports = [
    ./boot.nix
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
    ./pam-beacon-rs.nix
    ./printing.nix
    ./sound.nix
    ./vr.nix
    ./wooting.nix
    ./work.nix
    ./yubikey.nix
  ];

  nixpkgs.overlays = [ (import ../../overlays/aws-vpn-client.nix) ];

  environment.systemPackages = with pkgs; [
    nano
    wget
    curl
    git
    openssl

    fastfetch
    htop

    nix-index

    # provides a default authentification client for policykit
    lxqt.lxqt-policykit

    inputs.agenix.packages.${system}.default

    inputs.nix-inspect.packages.${system}.default
    awsvpnclient
  ];
  services.dbus.packages = [ pkgs.awsvpnclient ];
  systemd.packages = [ pkgs.awsvpnclient ];

  hardware.opentabletdriver.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
}
