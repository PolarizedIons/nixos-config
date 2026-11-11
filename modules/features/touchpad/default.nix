{ ... }:

{
  flake.nixosModules.touchpad = { config, ... }: {
    services.libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.disableWhileTyping = config.hardware.asahi.enable;
    };
  };
}
