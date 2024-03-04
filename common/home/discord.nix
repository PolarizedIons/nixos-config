{ config, lib, setup, ... }: {
  home.file.".config/discord/settings.json" = {
    enable = setup.chatting.enable;
    text = ''
      {
          "SKIP_HOST_UPDATE": true
      }
    '';
  };
}
