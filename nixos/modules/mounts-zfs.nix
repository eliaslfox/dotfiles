{ ... }:

{
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "lazytime" "noexec" "nosuid" "nodev" ];
  };

  # tmp needs to be executable and world writeable
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=1777" "lazytime" "nosuid" "nodev" ];
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
    options = [ "lazytime" "noexec" "nosuid" "nodev" ];
  };

  fileSystems."/var/lib/docker" = {
    device = "zroot/root/var/lib/docker";
    fsType = "zfs";
    options = [ "noatime" "noexec" "nosuid" "nodev" ];
  };

  # mount persisted user directories
  fileSystems."/home/elf/Documents" = {
    device = "zroot/home/elf/Documents";
    fsType = "zfs";
    options = [ "lazytime" "nosuid" "nodev" ];
  };
  fileSystems."/home/elf/.config" = {
    device = "zroot/home/elf/.config";
    fsType = "zfs";
    options = [ "lazytime" "nosuid" "nodev" ];
  };
  fileSystems."/home/elf/.local/share" = {
    device = "zroot/home/elf/.local/share";
    fsType = "zfs";
    options = [ "lazytime" "nosuid" "nodev" ];
  };

  services.zfs = {
    autoScrub = {
      enable = true;
      pools = [ "zroot" ];
    };
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };
}
