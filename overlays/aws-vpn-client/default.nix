{ pkgs }:

# Took patches from: https://github.com/BOPOHA/aws-rpm-packages/tree/main/awsvpnclient
# Also took insperation from https://gist.github.com/jefdaj/9c88c5f9712f33faf7b1

let
  stdenv = pkgs.stdenv;
  fetchurl = pkgs.fetchurl;
  buildFHSEnv = pkgs.buildFHSEnv;
  autoPatchelfHook = pkgs.autoPatchelfHook;
  copyDesktopItems = pkgs.copyDesktopItems;
  makeDesktopItem = pkgs.makeDesktopItem;
  libredirect = pkgs.libredirect;

  openvpn = pkgs.openvpn.overrideAttrs (oldAttrs: rec {
    patches = [
      (pkgs.fetchpatch {
        url =
          "https://raw.githubusercontent.com/ymatsiuk/aws-vpn-client/master/openvpn-v2.6.8-aws.patch";
        hash = "sha256-pbgmt5o/0k4lZ/mZobl0lgg39kxEASpk5hf6ndopayY=";
      })
    ];
  });

  mkDebianPackage = desc:
    let
      deb = mkPkg desc;

      src = fetchurl {
        url = desc.url;
        inherit (desc) sha256;
      };

      mkPkg = pkg:
        stdenv.mkDerivation (pkg // {
          inherit src;

          runScript = "${pkg.script} $@";

          buildInputs = with pkgs; [
            curl
            openssl_1_1
            icu70.dev
            icu70.out
            icu70
            lttng-ust_2_12
            gtk3
            xdg-utils
            lsof
            glibc.out
            stdenv.cc.cc.lib
            openvpn
          ];
          nativeBuildInputs = [
            autoPatchelfHook
            copyDesktopItems
            pkgs.icu70
            pkgs.openssl_1_1
            pkgs.glibc.out
            stdenv.cc.cc.lib
            openvpn
            pkgs.makeWrapper
          ];

          unpackPhase = ''
            ${pkgs.dpkg}/bin/dpkg -x "$src" unpacked
            mkdir -p "$out"
            cp -r unpacked/* "$out/"
            addAutoPatchelfSearchPath "$out/opt/awsvpnclient/Service"
            addAutoPatchelfSearchPath "$out/opt/awsvpnclient/Service/Resources/openvpn"
          '';

          acvcGtkServiceDepsPatch =
            pkgs.writeText "acvc.gtk.Services.deps.patch"
            (builtins.readFile ./acvc.gtk.Service.deps.patch);
          acvcGtkServiceRuntimeConfigPatch =
            pkgs.writeText "acvc.gtk.Service.runtimeconfig.patch"
            (builtins.readFile ./acvc.gtk.Service.runtimeconfig.patch);
          awsvpnclientDepsPatch = pkgs.writeText "awsvpnclient.deps.patch"
            (builtins.readFile ./awsvpnclient.deps.patch);
          awsvpnclientDesktopPatch = pkgs.writeText "awsvpnclient.desktop.patch"
            (builtins.readFile ./awsvpnclient.desktop.patch);
          awsvpnclientRuntimeConfigPatch =
            pkgs.writeText "awsvpnclient.runtimeconfig.patch"
            (builtins.readFile ./awsvpnclient.runtimeconfig.patch);

          fixupPhase = ''
            # Workaround for missing compatibility of the SQL library, intentionally breaking the metrics agent
            # It will be unable to load the dynamic lib and wont start but continue with error message
            rm "$out/opt/awsvpnclient/SQLite.Interop.dll"

            patch -s "$out/opt/awsvpnclient/Service/ACVC.GTK.Service.deps.json" $acvcGtkServiceDepsPatch
            patch -s "$out/opt/awsvpnclient/Service/ACVC.GTK.Service.runtimeconfig.json" $acvcGtkServiceRuntimeConfigPatch
            patch -s "$out/usr/share/applications/awsvpnclient.desktop" $awsvpnclientDesktopPatch
            patch -s "$out/opt/awsvpnclient/AWS VPN Client.deps.json" $awsvpnclientDepsPatch



            wrapProgram "$out/opt/awsvpnclient/Service/ACVC.GTK.Service" \
              --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
              --set NIX_REDIRECTS /bin/ps=/${
                pkgs.writeShellScript "fake_ps" ''
                  # # trick the application into thinking it's running as root
                  # if [[ $1 == "-o" && $2 == "user=" && $3 == "-p" ]]; then
                  #   echo "root"
                  # else               
                    ${pkgs.ps}/bin/ps $@
                  # fi
                ''
              }

            # mkdir -p "$out/share/applications"
            # cp "$out/usr/share/applications/awsvpnclient.desktop" "$out/share/applications/awsvpnclient.desktop"
          '';
        });

      desktopItem = (makeDesktopItem {
        name = deb.pname;
        desktopName = "AWS VPN Client";
        exec = "awsvpnclient-wrapped";
        icon = "${deb.out}/usr/share/pixmaps/acvc-64.png";
        categories = [ "Network" "X-VPN" ];
      });

      dbusFHSEnv = buildFHSEnv {
        name = deb.pname + "-dbus-wrapped";
        inherit (deb) version;

        runScript =
          # "bash";
          "/opt/awsvpnclient/Service/ACVC.GTK.Service";

        profile = ''
          sysctl net.ipv4.ip_forward=0
        '';
        extraBwrapArgs = [
          "--tmpfs /opt/awsvpnclient/Resources"
          "--tmpfs /sbin"
          "--symlink ${
            pkgs.writeShellScript "fake_sysctl" "${pkgs.busybox}/bin/true"
          } /sbin/sysctl"
          "--symlink ${pkgs.iproute2}/bin/ip /sbin/ip"
          # "--perms 0755"
          # "--bind /bin /bin"
          # "--bind ${pkgs.ps}/bin/ps /bin/ps"
          # "--symlink ${pkgs.ps}/bin/ps /bin/ps"
        ];

        # extraInstallCommands = ''
        #   mkdir -p "$out/bin"
        #   echo <<EOF > "$out/bin/ps"
        #   #!${pkgs.bash}/bin/bash
        #   echo "root"
        #   EOF
        #   chmod +x "$out/bin/ps"
        # '';

        targetPkgs = _: [ deb ];
        multiPkgs = _:
          with pkgs; [
            dpkg
            icu70
            gtk3
            xdg-utils
            lsof
            openssl_1_1
            glibc.out
            stdenv.cc.cc.lib
            openvpn
          ];
      };

    in buildFHSEnv {
      inherit (deb) version runScript;
      name = deb.pname + "-wrapped";

      targetPkgs = _: [ deb ];
      multiPkgs = _:
        with pkgs; [
          dpkg
          icu70
          gtk3
          xdg-utils
          lsof
          openssl_1_1
          glibc.out
          stdenv.cc.cc.lib
          openvpn
        ];
      extraInstallCommands = ''

        # mkdir -p $out/share/dbus-1/system-services
        # cp --recursive "${deb}/share" "$out"

        # mkdir -p "$out/share/dbus-1/system-services"
        # cat <<EOF > "$out/share/dbus-1/system-services/com.amazon.awsvpnclient.AwsVpnClientService.service"
        # [D-BUS Service]
        # Name=com.amazon.awsvpnclient.AwsVpnClientService
        # Exec=${dbusFHSEnv}/bin/${dbusFHSEnv.name}
        # User=root
        # #SystemdService=awsvpnclient.service
        # EOF

        mkdir -p "$out/share/systemd/user"
        # cat <<EOF > "$out/share/systemd/user/AwsVpnClientService.service"
        # [Unit]
        # Description=AWS VPN Client Service
        # PartOf=graphical-session.target

        # [Service]
        # BusName=com.amazon.awsvpnclient.AwsVpnClientService
        # ExecStart=${dbusFHSEnv}/bin/${dbusFHSEnv.name}
        # Type=dbus
        # User=root

        # [Install]
        # WantedBy=multi-user.target
        # EOF

        mkdir -p "$out/lib/systemd/system"
        cat <<EOF > "$out/lib/systemd/system/AwsVpnClientService.service"
        [Service]
        Type=simple
        ExecStart=${dbusFHSEnv}/bin/${dbusFHSEnv.name}
        Restart=always
        RestartSec=1s
        User=root

        [Install]
        WantedBy=multi-user.target
        EOF


        cp --recursive "${desktopItem}/share" "$out/"

      '';
    };

in pkgsDetails:

mkDebianPackage rec {
  inherit (pkgsDetails) version sha256;
  pname = "awsvpnclient";

  url =
    "https://d20adtppz83p9s.cloudfront.net/GTK/${version}/awsvpnclient_amd64.deb";
  script =
    # "bash";
    # "/opt/awsvpnclient/Service/ACVC.GTK.Service"; 
    "/opt/awsvpnclient/AWS\\ VPN\\ Client";
}
