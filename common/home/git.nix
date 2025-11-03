{ user, ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings.user = {
      name = user.name;
      email = user.email;
    };
  };
}
