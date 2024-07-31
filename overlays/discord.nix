final: prev: {
  discord = prev.discord.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs or [ ] ++ [ prev.pkgs.makeWrapper ];
    postInstall = oldAttrs.postInstall or "" + ''
      wrapProgram $out/opt/Discord/Discord \
        --set XDG_SESSION_TYPE x11
    '';
  });
}
