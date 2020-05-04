{ pkgs, runCommand, ... }:

# This script modifys the default pulseaudio config file so that it skips loading the module esound-protocol-unix.
# This module is unneeded and creates the file ~/.esd_auth.
runCommand "pulse-config" { } ''
  mkdir -p $out
  cat ${pkgs.pulseaudio}/etc/pulse/default.pa | sed -E "s/load-module module-esound-protocol-unix//" > $out/default.pa
''
