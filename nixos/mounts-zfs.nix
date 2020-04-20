{ ... }:

{
  /* mount a tmpfs on / */
  fileSystems."/" =
    { device = "tmpfs";
      fsType = "tmpfs";
      options = [ "mode=0755" ];
    };

  /* mount the nix store */
  fileSystems."/nix" =
    { device = "zroot/root/nix";
      fsType = "zfs";
    };

  /* mount persisted directories */
  fileSystems."/root" =
    { device = "zroot/root/root";
      fsType = "zfs";
    };

  fileSystems."/var/lib/docker" =
    { device = "zroot/root/var/lib/docker";
      fsType = "zfs";
    };

  fileSystems."/var/lib/libvirt" =
    { device = "zroot/root/var/lib/libvirt";
      fsType = "zfs";
    };


  fileSystems."/var/log/journal" =
    { device = "zroot/root/var/log/journal";
      fsType = "zfs";
    };

  /* mount persisted user directories */
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
