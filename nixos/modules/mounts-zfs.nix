{ ... }:

{
  # mount a tmpfs on /
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=0755" "noexec" ];
  };

  fileSystems."/run/wrappers" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "noexec" ];
  };

  # mount the nix store
  fileSystems."/nix" = {
    device = "zroot/root/nix";
    fsType = "zfs";
    options = [ "noatime" "nosuid" ];
  };

  # mount persisted directories
  fileSystems."/root" = {
    device = "zroot/root/root";
    fsType = "zfs";
    options = [ "noatime" "noexec" ];
  };

  fileSystems."/var/lib/docker" = {
    device = "zroot/root/var/lib/docker";
    fsType = "zfs";
    options = [ "noatime" "noexec" ];
  };

  # mount persisted user directories
  fileSystems."/home/elf/Documents" = {
    device = "zroot/home/elf/Documents";
    fsType = "zfs";
    options = [ "noatime" "nosuid" ];
  };

  fileSystems."/home/elf/.cache" = {
    device = "zroot/home/elf/.cache";
    fsType = "zfs";
    options = [ "noatime" "noexec" ];
  };

  fileSystems."/home/elf/.config" = {
    device = "zroot/home/elf/.config";
    fsType = "zfs";
    options = [ "noatime" "nosuid" ];
  };

  fileSystems."/home/elf/.local" = {
    device = "zroot/home/elf/.local";
    fsType = "zfs";
    options = [ "noatime" "exec" ];
  };
}
