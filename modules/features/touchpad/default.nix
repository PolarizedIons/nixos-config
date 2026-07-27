{ ... }:

{
  flake.nixosModules.touchpad = { ... }: {
    services.libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.disableWhileTyping = false;
    };
  };
}
