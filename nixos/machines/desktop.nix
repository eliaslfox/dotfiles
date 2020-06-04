{ config, lib, pkgs, ... }:
let
  scripts = pkgs.callPackage (import ../users/elf/scripts.nix) { };
  credentials = import ../credentials.nix { };

in
{
  imports = [
    <nixos/nixos/modules/profiles/hardened.nix>
    ../modules/xorg.nix
    ../modules/mounts-zfs.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest_hardened;

    kernel.sysctl = {
      /* 
       * Allow normal users to use userns
       * this is needed for nix and chromium
       * this is added by the hardened patchset
       */
      "kernel.unprivileged_userns_clone" = true;
    };

    kernelModules = [ "kvm_amd" ];
    kernelParams = [ "amd_iommu=on" "iommu=pt" ];
    extraModprobeConfig = ''
      options iwlwifi 11n_disable=1

      options vfio-pci ids=10de:1c81,10de:0fb9
      blacklist nouveau
      softdep nvidia pre: vfio-pci
      softdep nvidia* pre: vfio-pci
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
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "vfio-pci" ];
      luks = {
        devices = {
          root.device = "/dev/disk/by-uuid/edc067ee-6d0a-445e-a05a-28f25c2409dd";
          stuff.device = "/dev/disk/by-uuid/04c4a351-9e58-41b3-add1-4e3cd2759155";
        };
      };
    };
  };

  features = {
    mopidy.enable = true;
    steam.enable = true;
    wireguard = {
      enable = true;
      wirelessInterface = "wlp6s0";
      extraInterfaces = [ "enp4s0" ];
      credentials = credentials.wireguard;
    };
    docker.enable = true;
    dnscrypt = {
      enable = true;
      localDoh.enable = true;
    };
    internet-sharing = {
      enable = true;
      externalInterface = "wlp6s0";
      internalInterface = "enp4s0";
    };
    vm-bridge.enable = true;
    horriblesubsd.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  networking = {
    hostName = "darling";
    hostId = "8425e349";
    wireless.interfaces = [ "wlp6s0" ];
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
    home.packages = with pkgs; [ qemu_kvm minikube OVMF nvtop ];
    services.picom.enable = true;
  };

  fileSystems."/efi" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [ "noexec" "nodev" ];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4";
    options = [ "noexec" "nodev" ];
  };

  fileSystems."/run/media/elf/stuff" = {
    device = "/dev/mapper/stuff";
    fsType = "btrfs";
    options = [ "subvol=stuff" "compress=zstd" "noexec" "nodev" ];
  };

  fileSystems."/run/media/elf/backup" = {
    device = "/dev/mapper/backup";
    fsType = "btrfs";
    options = [ "subvol=backup" "noauto" "compress=lzo" "noexec" "nodev" ];
  };

  security = {
    allowSimultaneousMultithreading = true;
    lockKernelModules = false;
    allowUserNamespaces = true;
  };
  environment.memoryAllocator.provider = "libc";

  nix = {
    maxJobs = lib.mkDefault 12;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
