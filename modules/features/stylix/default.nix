{ inputs, ... }:

{

  flake.nixosModules.stylix = { pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/shadesmear-dark.yaml";
      polarity = "dark";
      image = ./wallpaper.jpg;
      fonts = {
        monospace = {
          package = pkgs.meslo-lgs-nf;
          name = "MesloLGS NF";
        };
      };
    };
  };
}
