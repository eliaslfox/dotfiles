{ pkgs, ... }:

{
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

  mountBackup = pkgs.writeScriptBin "mountBackup" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    sudo cryptsetup luksOpen /dev/disk/by-uuid/607af807-a3fd-42cd-adc6-ac69a8ce2074 backup
    sudo mkdir /run/media/elf/backup
    sudo mount /run/media/elf/backup
  '';

  physexec = pkgs.writeScriptBin "physexec" ''
    #! ${pkgs.bash}/bin/bash
    set -eou pipefail

    exec sudo -E ${pkgs.iproute}/bin/ip netns exec physical \
         sudo -E -u \#$(${pkgs.coreutils}/bin/id -u) \
                 -g \#$(${pkgs.coreutils}/bin/id -g) \
                 "$@"
  '';

  elf-i3status = pkgs.writeScriptBin "elf-i3status" ''
    #!${pkgs.bash}/bin/bash
    set -eou pipefail

    exec ${pkgs.iproute}/bin/ip netns exec physical ${pkgs.i3status}/bin/i3status -c /home/elf/.config/i3status/config
  '';
}
