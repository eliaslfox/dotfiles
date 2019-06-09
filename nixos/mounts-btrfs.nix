{ ... }:

{
   fileSystems."/home/elf" =
    { device = "tmpfs";
      fsType = "tmpfs";
      options = [ "mode=0755" ];
    };

  fileSystems."/home/elf/Documents" =
    { device = "/dev/vg/root";
      fsType = "btrfs";
      options = [ "subvol=home/elf/Documents" ];
    };

  fileSystems."/home/elf/.cache" =
    { device = "/dev/vg/root";
      fsType = "btrfs";
      options = [ "subvol=home/elf/.cache" ];
    };

  fileSystems."/home/elf/.config" =
    { device = "/dev/vg/root";
      fsType = "btrfs";
      options = [ "subvol=home/elf/.config" ];
    };

  fileSystems."/home/elf/.local" =
    { device = "/dev/vg/root";
      fsType = "btrfs";
      options = [ "subvol=home/elf/.local" ];
    };
}
