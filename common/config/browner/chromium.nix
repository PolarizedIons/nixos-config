{ pkgs, nixpkgs, ... }: {
  environment.systemPackages = with pkgs; [ chromium ];
  nixpkgs.config = { chromium = { enableWideVine = true; }; };
}
