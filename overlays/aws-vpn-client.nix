# https://gist.github.com/jefdaj/9c88c5f9712f33faf7b1
let pkgs = import <nixpkgs> { };
in let
  stdenv = pkgs.stdenv;
  fetchurl = pkgs.fetchurl;
  buildFHSUserEnv = pkgs.buildFHSUserEnv;
  autoPatchelfHook = pkgs.autoPatchelfHook;
  mkDebianPackage = desc:
    let
      deb = mkPkg desc;
      mkPkg = pkg:
        stdenv.mkDerivation (pkg // {
          inherit (pkgs) dpkg;
          builder = ./builder.sh;
          runScript = "${pkg.script} $@";
          buildInputs = with pkgs; [ zlib curl openssl icu70.dev ];
          nativeBuildInputs = [ autoPatchelfHook ];
          src = fetchurl {
            url = desc.url; # mkUrl { inherit (desc) name version; };
            inherit (desc) sha256;
          };

          dontPatchELF = true;
          dynamicLinker = stdenv.cc.bintools.dynamicLinker;
          rpath = pkgs.lib.makeLibraryPath
            (with pkgs; [ stdenv.cc.cc icu70 openssl zlib curl ]);
        });

    in buildFHSUserEnv {
      inherit (deb) name runScript;
      targetPkgs = pkgs: [ deb ];
      multiPkgs = pkgs: [ pkgs.dpkg ];
    };
in mkDebianPackage {
  name = "aws-vpn-client";
  url =
    "https://d20adtppz83p9s.cloudfront.net/GTK/3.14.0/awsvpnclient_amd64.deb";
  version = "3.14.0";
  script = "/opt/awsvpnclient/AWS\\ VPN\\ Client";
  sha256 = "bd2b401a1ede6057d725a13c77ef92147a79e0c5e0020d379e44f319b5334f60";
}
