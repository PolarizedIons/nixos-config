{ pkgs, inputs, system, config, ... }:

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
    ./printing.nix
    ./sound.nix
    ./tailscale.nix
    ./vr.nix
    ./wooting.nix
    ./yubikey.nix
  ];

  nixpkgs.overlays = [
    (import ../../overlays/stable-electron.nix)
    (import ../../overlays/pr-fixes.nix)
  ];

  environment.systemPackages = with pkgs; [
    nano
    wget
    curl
    git
    openssl

    fastfetch
    htop
    btop

    nix-index

    # provides a default authentification client for policykit
    lxqt.lxqt-policykit

    inputs.agenix.packages.${system}.default

    # inputs.nix-inspect.packages.${system}.default
  ];

  hardware.opentabletdriver.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # disable built-in command-not-found, which doesn't work with flakes
  programs.command-not-found.enable = false;
  programs.zsh.interactiveShellInit = ''
    source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
  '';

  programs.corectrl.enable = config.setup.video-driver == "amdgpu";
  powerManagement.cpuFreqGovernor = "performance";

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
