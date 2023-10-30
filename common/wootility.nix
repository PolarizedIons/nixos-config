{ lib, pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [ wootility ];

  nixpkgs.overlays = [
    (self: super: {
      wootility =
        super.wootility.overrideAttrs (old: rec { version = "4.6.7"; });
    })
  ];

}
