{ ... }:

{
  users.users.polarizedions = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" ];
  };
}
