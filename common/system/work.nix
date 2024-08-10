{ config, lib, pkgs, inputs, system, ... }: {
  imports = [ inputs.aws-vpn-client.nixosModules.${system}.default ];

  config = lib.mkIf config.setup.work-mode.enable {
    programs.awsvpnclient.enable = true;

    environment.systemPackages = with pkgs;
      lib.mkMerge [
        (if config.setup.chatting.enable then [ slack ] else [ ])
        (if config.setup.coding.enable then [
          cypress
          awscli2
          inputs.awsvpnclient.packages.${system}.awsvpnclient
        ] else
          [ ])
        (if config.setup.media.enable then [ libreoffice ] else [ ])
      ];

    nixpkgs.overlays = [
      (import ../../overlays/cypress.nix {
        v = "12.17.1";
        ## Note: sha256 is computed via (note the version):
        ## nix-prefetch-url --unpack https://cdn.cypress.io/desktop/12.17.1/linux-x64/cypress.zip
        sha = "079c0q5bfiqm7n040sh3vr8z7jy26180alrb9iy7kk8jgca6sdy3";
      })
    ];

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all 172.17.0.1/4 trust
        host all all ::1/128 trust
      '';
    };

    environment.sessionVariables = { ASPNETCORE_ENVIRONMENT = "Local"; };
  };
}
