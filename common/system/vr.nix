{ config, lib, inputs, system, ... }: {
  config = lib.mkIf config.setup.vr.enable {
    services.monado = {
      enable = true;
      defaultRuntime = true;
    };

    environment.systemPackages =
      [ inputs.vr-envision.packages.${system}.default ];
  };
}
