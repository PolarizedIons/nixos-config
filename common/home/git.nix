{ user, ... }: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = user.name;
    userEmail = user.email;
  };
}
