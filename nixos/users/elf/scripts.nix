{ pkgs, ... }:
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

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.cache/steam
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.cache/steam /home/elf/.steam

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.config/emacs.d
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.config/emacs.d /home/elf/.emacs.d

    ${pkgs.coreutils}/bin/mkdir -vp /home/elf/.local/share/stack
    ${pkgs.coreutils}/bin/ln -sfvT /home/elf/.local/share/stack /home/elf/.stack

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

  nixos-vm = pkgs.writeShellScriptBin "nixos-vm" ''
    #!${pkgs.bash}/bin/bash
    set -eou pipefail

    exec ${pkgs.qemu_kvm}/bin/qemu-kvm \
      -display none \
      -nodefaults \
      -machine type=q35,accel=kvm \
      -cpu host \
      -smp 12 \
      -m 20G \
      -vga virtio \
      -nic tap,ifname=tap0,script=no,downscript=no \
      -object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0 \
      -drive file=~/Documents/vm/nixos-main.img,if=virtio,cache=none
  '';

  nixos-vm-graphic = pkgs.writeShellScriptBin "nixos-vm-graphic" ''
    #!${pkgs.bash}/bin/bash
    set -eou pipefail

    exec ${pkgs.qemu_kvm}/bin/qemu-kvm \
      -display gtk \
      -nodefaults \
      -machine type=q35,accel=kvm \
      -cpu host \
      -smp 12 \
      -m 20G \
      -vga virtio \
      -nic tap,ifname=tap0,script=no,downscript=no \
      -object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0 \
      -drive file=~/Documents/vm/nixos-main.img,if=virtio,cache=none
  '';

  nixos-vm-iso = pkgs.writeShellScriptBin "nixos-vm-iso" ''
    #!${pkgs.bash}/bin/bash
    set -eou pipefail

    exec ${pkgs.qemu_kvm}/bin/qemu-kvm \
      -display gtk \
      -nodefaults \
      -machine type=q35,accel=kvm \
      -cpu host \
      -smp 12 \
      -m 20G \
      -vga virtio \
      -nic tap,ifname=tap0,script=no,downscript=no \
      -object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0 \
      -drive file=~/Documents/vm/nixos-main.img,if=virtio,cache=none \
      -cdrom ~/Documents/vm/nixos.iso \
      -boot d
  '';

}
