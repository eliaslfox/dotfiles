{ ... }:

{
  fileSystems."/home/elf" = {
    fsType = "tmpfs";
    options = [ "uid=1000" ];
  };
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
