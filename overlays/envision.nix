final: prev: {
  envision = prev.envision.overrideAttrs (oldAttrs: {
    targetPkgs = oldAttrs.targetPkgs or [ ]
      ++ (with prev.pkgs; [ cargo libclang libusb1 ]);
  });
}
