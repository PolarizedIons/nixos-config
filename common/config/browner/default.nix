{ config, ... }:

{
  imports = builtins.map (br: ./${br}.nix) config.setup.browsers;
}
