{ ... }:

{
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "noatime" "noexec" "nodev" ];
  };

  # tmp needs to be executable and world writeable
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=1777" "noatime" "nosuid" "nodev" ];
  };

  # mount the nix store
  fileSystems."/nix" = {
    device = "zroot/root/nix";
    fsType = "zfs";
    options = [ "noatime" "nosuid" "nodev" ];
  };

  # mount persisted directories
  fileSystems."/root" = {
    device = "zroot/root/root";
    fsType = "zfs";
    options = [ "noatime" "noexec" "nodev" ];
  };

  fileSystems."/var/lib/docker" = {
    device = "zroot/root/var/lib/docker";
    fsType = "zfs";
    options = [ "noatime" "nosuid" "nodev" ];
  };

  # mount persisted user directories
  fileSystems."/home/elf/Documents" = {
    device = "zroot/home/elf/Documents";
    fsType = "zfs";
    options = [ "noatime" "nosuid" "nodev" ];
  };
  fileSystems."/home/elf/.config" = {
    device = "zroot/home/elf/.config";
    fsType = "zfs";
    options = [ "noatime" "nosuid" "nodev" ];
  };
  fileSystems."/home/elf/.local/share" = {
    device = "zroot/home/elf/.local/share";
    fsType = "zfs";
    options = [ "noatime" "noexec" "nodev" ];
  };
}
