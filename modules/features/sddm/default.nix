{ self, lib, ... }:

{

  flake.nixosModules.sddm = { pkgs, ... }: {
    services.displayManager.sddm = {
      enable = true;
      package = lib.mkForce self.packages."${pkgs.stdenv.hostPlatform.system}".sddm;
      wayland.enable = true;
      autoNumlock = true;
      theme = "${pkgs.sddm-astronaut}/share/sddm/themes/sddm-astronaut-theme";

      extraPackages = with pkgs; [
        kdePackages.qtmultimedia
      ];
    };
  };

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.sddm = pkgs.kdePackages.sddm;
    };
}
