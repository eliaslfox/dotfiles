{ pkgs, ... }:

{
  symlink-init = pkgs.writeScriptBin "symlink-init" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/steam-install
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/steam-install /home/elf/.steam

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/mozilla
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/mozilla /home/elf/.mozilla

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/stack
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/stack /home/elf/.stack

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/ghc
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/ghc /home/elf/.ghc

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/cabal
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/cabal /home/elf/.cabal

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.config/npmpcpp
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/npmpcpp /home/elf/.ncmpcpp

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.config/ssh
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/ssh /home/elf/.ssh
  '';

  /*
  ncmpcpp-notify = pkgs.writeScriptBin "ncmpcpp-notify" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    MPC=${pkgs.mpc_cli}/bin/mpc
    IFS=$'\t' read album artist title \
      <<< "$($MPC --format="%album%\t%artist%\t%title%")"

    ${pkgs.libnotify}/bin/notify-send --app-name=ncmpcpp --icon=audio-x-generic \
        "$title" "$artist\n$album"
    '';
    */

    mopidy-audio-pipe = pkgs.writeScriptBin "mopidy-audio-pipe" ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      if [ -f /tmp/mpd.fifo ]; then
        ${pkgs.coreutils}/bin/mkfifo /tmp/mpd.fifo
      fi

      while :; do
        ${pkgs.coreutils}/bin/yes $’\n’ | ${pkgs.netcat}/bin/nc -lu 127.0.0.1 5555 > /tmp/mpd.fifo;
      done
    '';

    mpd-notifyd = pkgs.writeScriptBin "mpd-notifyd" ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      ${pkgs.mpc_cli}/bin/mpc idleloop | while read -r cmd; do
        if [ $cmd == "mixer" ]; then
          ${pkgs.coreutils}/bin/sleep .1
          ${pkgs.libnotify}/bin/notify-send "$(${pkgs.mpc_cli}/bin/mpc --format "%title%\n%artist%\n%album%" | ${pkgs.coreutils}/bin/head -3)" --icon=audio-x-generic
        fi
      done
    '';
}
