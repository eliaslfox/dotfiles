{ pkgs, ... }:

let
  multimc = pkgs.writeShellScriptBin "multimc" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    ${pkgs.multimc}/bin/multimc -d "$HOME/.cache/multimc"
  '';

  iommuGroups = pkgs.writeScriptBin "iommuGroups" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

     shopt -s nullglob
     for d in /sys/kernel/iommu_groups/*/devices/*; do
         n=''${d#*/iommu_groups/*}; n=''${n%%/*}
         printf 'IOMMU Group %s ' "$n"
         ${pkgs.pciutils}/bin/lspci -nns "''${d##*/}"
     done;
  '';

  startBackup = pkgs.writeScriptBin "startBackup" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    DISPLAY=:0.0 ${pkgs.libnotify}/bin/notify-send -u critical 'Starting Backup'

    LATEST=$(ls /run/media/elf/stuff/backups | sort | head -n1)

    echo "Last backup $LATEST"

    TIMESTAMP=$(date +%s)

    echo "Current timestamp $TIMESTAMP"

    btrfs subvol snapshot -r /run/media/elf/stuff /run/media/elf/stuff/backups/$TIMESTAMP
    sync
    btrfs send -p /run/media/elf/stuff/backups/$LATEST /run/media/elf/stuff/backups/$TIMESTAMP | btrfs receive /run/media/elf/backup
    rm -r /run/media/elf/stuff/backups/$LATEST
    rm -r /run/media/elf/stuff/backup/$LATEST

    DISPLAY=:0.0 ${pkgs.libnotify}/bin/notify-send -u critical 'Backup Complete'
  '';

  mountBackup = pkgs.writeScriptBin "mountBackup" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    sudo cryptsetup luksOpen /dev/disk/by-uuid/607af807-a3fd-42cd-adc6-ac69a8ce2074 backup
    sudo mkdir /run/media/elf/backup
    sudo mount /run/media/elf/backup
  '';

in {
  environment.systemPackages = [ multimc iommuGroups startBackup mountBackup ];
}
