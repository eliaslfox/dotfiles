{ ... }:

{
  /* Root File System */
  fileSystems."/" = {
    fsType = "tmpfs";
  };

  /* Sys File Systems */
  fileSystems."/bin" = {
    device = "/dev/vg/root";
    fsType = "btrfs";
    options = [ "subvol=rootfs/bin" ];
  };
  fileSystems."/etc" = {
    device = "/dev/vg/root";
    fsType = "btrfs";
    options = [ "subvol=rootfs/etc" ];
  };
  fileSystems."/nix" = {
    device = "/dev/vg/root";
    fsType = "btrfs";
    options = [ "subvol=rootfs/nix" ];
  };
  fileSystems."/usr" = {
    device = "/dev/vg/root";
    fsType = "btrfs";
    options = [ "subvol=rootfs/usr" ];
  };
  fileSystems."/var" = {
    device = "/dev/vg/root";
    fsType = "btrfs";
    options = [ "subvol=rootfs/var" ];
  };

  /* User File Systems */
  fileSystems."/home/elf/Documents" = {
    device = "/dev/vg/root";
    fsType = "btrfs";
    options = [ "subvol=home/elf/Documents" ];
  };
  fileSystems."/home/elf/.config" = {
    device = "/dev/vg/root";
    fsType = "btrfs";
    options = [ "subvol=home/elf/.config" ];
  };
  fileSystems."/home/elf/.local" = {
   device = "/dev/vg/root";
   fsType = "btrfs";
   options = [ "subvol=home/elf/.local" ];
  };
  fileSystems."/home/elf/.cache" = {
    device = "/dev/vg/root";
    fsType = "btrfs";
    options = [ "subvol=home/elf/.cache" ];
  };
}
