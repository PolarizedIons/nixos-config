{ config, lib, pkgs, inputs, ... }:

{
  config = lib.mkIf config.setup.vr.enable {
    services.monado = {
      enable = true;
      defaultRuntime = true; # Register as default OpenXR runtime
    };

    systemd.user.services.monado.environment = {
      # STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
    };

    # programs.envision.enable = true;

    boot.kernelPatches = [{
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url =
          "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
      };
    }];
  };
}
