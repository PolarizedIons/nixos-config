{ self, ... }:

{
  flake.nixosModules.virgil = { lib, ... }: {
    imports = with self.nixosModules; [ virgilHardware ];

    networking.hostName = "virgil";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;

    networking.useDHCP = lib.mkForce true; # Why is force ne

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.11";  # Did you read the comment?
  };
}
