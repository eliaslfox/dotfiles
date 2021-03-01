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

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/vagrant
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/vagrant /home/elf/.vagrant.d

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.config/zoom
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/zoom /home/elf/.zoom


    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/steam
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/steam /home/elf/.steam
  '';

  set-bg = pkgs.writeScriptBin "set-bg" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    ${pkgs.feh}/bin/feh --no-fehbg --bg-scale ~/Documents/.backgrounds/background.png
  '';

  multimc = pkgs.writeShellScriptBin "multimc" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    exec ${pkgs.multimc}/bin/multimc -d "$HOME/.local/share/multimc"
  '';

  libreoffice = pkgs.writeScriptBin "libreoffice" ''
    #!${pkgs.bash}/bin/bash
    set -eou pipefail

    export GTK_THEME=Adwaita:light 
    exec ${pkgs.libreoffice}/bin/libreoffice
  '';

}
