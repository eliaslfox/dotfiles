{ ... }:

{
  fileSystems."/" =
    { device = "tmpfs";
      fsType = "tmpfs";
      options = [ "mode=0755" ];
    };

  fileSystems."/bin" =
    { device = "zroot/rootfs/bin";
      fsType = "zfs";
    };

  fileSystems."/etc" =
    { device = "zroot/rootfs/etc";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "zroot/rootfs/nix";
      fsType = "zfs";
    };

  fileSystems."/usr" =
    { device = "zroot/rootfs/usr";
      fsType = "zfs";
    };

  fileSystems."/var" =
    { device = "zroot/rootfs/var";
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
