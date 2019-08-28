{ ... }:

{
  fileSystems."/" =
    { device = "tmpfs";
      fsType = "tmpfs";
      options = [ "mode=0755" ];
    };

  fileSystems."/bin" =
    { device = "zroot/root/bin";
      fsType = "zfs";
    };

  fileSystems."/etc" =
    { device = "zroot/root/etc";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "zroot/root/nix";
      fsType = "zfs";
    };

  fileSystems."/usr" =
    { device = "zroot/root/usr";
      fsType = "zfs";
    };

  fileSystems."/root" =
    { device = "zroot/root/root";
      fsType = "zfs";
    };

  fileSystems."/var" =
    { device = "zroot/root/var";
      fsType = "zfs";
    };

  fileSystems."/home/elf/Documents" =
    { device = "zroot/home/elf/Documents";
      fsType = "zfs";
    };

  fileSystems."/home/elf/.cache" =
    { device = "zroot/home/elf/.cache";
      fsType = "zfs";
    };

  fileSystems."/home/elf/.config" =
    { device = "zroot/home/elf/.config";
      fsType = "zfs";
    };

  fileSystems."/home/elf/.local" =
    { device = "zroot/home/elf/.local";
      fsType = "zfs";
    };
}
