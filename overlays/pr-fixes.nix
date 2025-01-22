final: prev: {
  # Applies https://github.com/NixOS/nixpkgs/pull/375833 fix to v4l2loopback
  my-v4l2loopback = prev.linuxPackages_latest.v4l2loopback.overrideAttrs (old: {
    preBuild = (old.preBuild or "") + ''
      export buildRoot=.
    '';
  });
}
