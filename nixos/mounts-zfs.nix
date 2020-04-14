{ ... }:

{
  fileSystems."/" =
    { device = "tmpfs";
      fsType = "tmpfs";
      options = [ "mode=0755" ];
    };

  fileSystems."/nix" =
    { device = "zroot/root/nix";
      fsType = "zfs";
    };

  fileSystems."/root" =
    { device = "zroot/root/root";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    { device = "zroot/root/persist";
      fsType = "zfs";
    };

  environment.etc."NetworkManager/system-connections" = {
    source = "/persist/etc/NetworkManager/system-connections/";
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
