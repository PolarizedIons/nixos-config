{ lib, ... }:

{
  options.username = lib.mkOption {
    type = lib.types.str;
    default = "polarizedions";
    description = "Username for this system target";
  };
}
