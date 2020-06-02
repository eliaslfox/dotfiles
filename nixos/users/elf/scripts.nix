{ config, lib, pkgs, ... }:
{
  symlink-init = pkgs.writeScriptBin "symlink-init" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/mozilla
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/mozilla /home/elf/.mozilla

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/ghc
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/ghc /home/elf/.ghc

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/cabal
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/cabal /home/elf/.cabal

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.config/ssh
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/ssh /home/elf/.ssh

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.config/emacs.d
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/emacs.d /home/elf/.emacs.d

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/stack
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/stack /home/elf/.stack

    ${lib.optionalString config.features.steam.enable ''
      ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/steam
      ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/steam /home/elf/.steam
    ''}
  '';

  ncmpcpp-notify = pkgs.writeScriptBin "ncmpcpp-notify" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    MPC=${pkgs.mpc_cli}/bin/mpc
    IFS=$'\t' read album artist title \
      <<< "$($MPC --format="%album%\t%artist%\t%title%")"

    ${pkgs.libnotify}/bin/notify-send --app-name=ncmpcpp --icon=audio-x-generic \
        "$title" "$artist\n$album"
  '';

  set-bg = pkgs.writeScriptBin "set-bg" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    ${pkgs.feh}/bin/feh --no-fehbg --bg-scale ~/Documents/backgrounds/background.png
  '';

  multimc = pkgs.writeShellScriptBin "multimc" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    ${pkgs.multimc}/bin/multimc -d "$HOME/.cache/multimc"
  '';
}
