_: super: {

  awsvpnclient =
    let mkAwsVpnClient = (import ./aws-vpn-client { inherit (super) pkgs; });
    in mkAwsVpnClient rec {
      version = "3.14.0";
      sha256 =
        "bd2b401a1ede6057d725a13c77ef92147a79e0c5e0020d379e44f319b5334f60";
    };
}
