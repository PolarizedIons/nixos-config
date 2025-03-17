final: prev: {
  envision = prev.envision.overrideAttrs (oldAttrs: {
    targetPkgs = oldAttrs.targetPkgs or [ ] ++ [ prev.pkgs.mesa ];
  });
}
