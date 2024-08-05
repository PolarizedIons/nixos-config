{ pkgs, ... }:

_: prev: {
  icalcli = let
    pythonPackages = pkgs.python3Packages;
    pname = "icalcli";
    version = "1.0.6";
  in pythonPackages.buildPythonApplication {
    inherit pname version;

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "sha256-nKSecI7qL1ch1oYw5nBlKIwD2U2tXVVnNGMcqHRmpwc=";
    };

    doCheck = false;

    dependencies = with pythonPackages; [
      icalendar
      recurring-ical-events
      parsedatetime
    ];
  };
}
