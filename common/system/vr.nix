{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  config = lib.mkIf config.setup.vr.enable {
    services.monado = {
      enable = true;
      defaultRuntime = true; # Register as default OpenXR runtime

      highPriority = true;

      #   package =
      #     with pkgs;
      #     monado.overrideAttrs (
      #       finalAttrs: previousAttrs: {
      #         src = fetchFromGitLab {
      #           domain = "gitlab.freedesktop.org";
      #           owner = "thaytan";
      #           repo = "monado";
      #           # here you need go to gitlab for this and find most suitable branch for your headset and replace string below
      #           # or remove whole package override
      #           rev = "dev-wmr-HP-G2-tunnelled-controller";
      #           hash = "sha256-bZBNYKJEegJgm/sDPYsxNCilu8s2ObCGcXAmfrgrmsQ=";
      #         };

      #         patches = [ ];
      #       }
      #     );
    };

    systemd.user.services.monado.environment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      IPC_EXIT_ON_DISCONNECT = "1";
      # VIT_SYSTEM_LIBRARY_PATH = "${pkgs.basalt-monado}/lib/libbasalt.so";
    };

    environment.systemPackages = with pkgs; [
      # envision
      basalt-monado
      opencomposite
    ];

    programs.steam.package = pkgs.steam.override {
      extraProfile = ''
        # Allows Monado/WiVRn to be used
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        # Fixes timezones on VRChat
        unset TZ
      '';
    };
    # nixpkgs.overlays = [ (import ../../overlays/envision.nix) ];

    # boot.kernelPatches = [{
    #   name = "amdgpu-ignore-ctx-privileges";
    #   patch = pkgs.fetchpatch {
    #     name = "cap_sys_nice_begone.patch";
    #     url =
    #       "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
    #     hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
    #   };
    # }];
  };
}
