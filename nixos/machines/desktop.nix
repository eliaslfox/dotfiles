{ config, lib, pkgs, ... }:

let scripts = pkgs.callPackage (import ../users/elf/scripts.nix) { };

in {
  imports = [
    <nixos/nixos/modules/profiles/hardened.nix>
    ../xorg.nix
    ../mounts-zfs.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor
      (pkgs.linuxPackages_latest_hardened.kernel.override {
        features.ia32Emulation = true;
        structuredExtraConfig = { IA32_EMULATION = { tristate = "y"; }; };
      });

    kernelModules = [ "kvm_amd" ];
    extraModprobeConfig = ''
      options iwlwifi 11n_disable=1
    '';

    loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 10;
    };

    initrd = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      luks.devices = {
        root.device = "/dev/disk/by-uuid/edc067ee-6d0a-445e-a05a-28f25c2409dd";
        stuff.device = "/dev/disk/by-uuid/04c4a351-9e58-41b3-add1-4e3cd2759155";
      };
    };
  };

  features = {
    mopidy.enable = true;
    steam.enable = true;
    wireguard = {
      enable = true;
      wirelessInterface = "wlp6s0";
      ethernetInterface = "enp4s0";
    };
  };

  hardware = { enableRedistributableFirmware = true; };

  networking = {
    hostName = "darling";
    hostId = "8425e349";
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xrandrHeads = [
      { output = "DP-5"; }
      {
        output = "DP-0";
        primary = true;
      }
    ];
    screenSection = ''
      Option    "metamodes" "DP-5: nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-0: nvidia-auto-select +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, AllowGSYNCCompatible=On}"
    '';
  };

  home-manager.users.elf = {
    home.packages = with pkgs; [ cura qemu_kvm ];
    services.picom.enable = true;
  };

  fileSystems."/efi" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [ "ro" "noexec" ];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4";
    options = [ "noexec" ];
  };

  fileSystems."/run/media/elf/stuff" = {
    device = "/dev/mapper/stuff";
    fsType = "btrfs";
    options = [ "subvol=stuff" "compress=zstd" "noexec" ];
  };

  fileSystems."/run/media/elf/backup" = {
    device = "/dev/mapper/backup";
    fsType = "btrfs";
    options = [ "subvol=backup" "noauto" "compress=lzo" "noexec" ];
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

  security = {
    allowSimultaneousMultithreading = true;
    lockKernelModules = false;
    allowUserNamespaces = true;
    chromiumSuidSandbox.enable = true;
  };

  nix = {
    maxJobs = lib.mkDefault 12;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
