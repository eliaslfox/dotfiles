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
       * Allow unprivileged users to use user namespaces
       * this is needed for the nix sandbox and chromium
       * this is added by the hardened patchset
       */
      "kernel.unprivileged_userns_clone" = true;
    };

    kernelModules = [ "kvm_amd" ];
    kernelParams = [ "iommu=pt" "nvidia-drm.modeset=1" ];
    extraModprobeConfig = ''
      # settings for intel wifi drivers
      options iwlwifi 11n_disable=1 power_save=1
      options iwlmvm power_scheme=1

      # use vfio-pci driver for gpu passthrough
      options vfio-pci ids=10de:1c81,10de:0fb9
      softdep nvidia pre: vfio-pci
      softdep nvidia* pre: vfio-pci
    '';

    # blacklisted 
    blacklistedKernelModules = [ "sp5100-tco" "tpm_crb" ];

    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "auto";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 5;
    };

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "vfio-pci" ];
      luks.devices = {
        root.device = "/dev/disk/by-uuid/edc067ee-6d0a-445e-a05a-28f25c2409dd";
        stuff.device = "/dev/disk/by-uuid/04c4a351-9e58-41b3-add1-4e3cd2759155";
      };
    };
  };

  features = {
    wireguard = {
      enable = true;
      wirelessInterface = "wlp6s0";
      extraInterfaces = [ "enp4s0" ];
      credentials = credentials.wireguard;
    };
    docker.enable = true;
    dnscrypt.enable = true;
    horriblesubsd.enable = false;
    printing.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    openrazer.enable = true;
    nvidia.modesetting.enable = true;
  };

  networking = {
    hostName = "darling";
    hostId = "8425e349";
    wireless.interfaces = [ "wlp6s0" ];
    interfaces.wlp6s0.useDHCP = true;
    firewall = {
      allowedTCPPortRanges = lib.mkForce [ ];
      allowedTCPPorts = lib.mkForce credentials.firewall.tcp;
      allowedUDPPortRanges = lib.mkForce [ ];
      allowedUDPPorts = lib.mkForce credentials.firewall.udp;
    };
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xrandrHeads = [
      {
        output = "DP-0";
        primary = true;
      }
      { output = "DP-5"; }
    ];
    screenSection = ''
      Option    "metamodes" "DP-1: nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-4: nvidia-auto-select +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, AllowGSYNCCompatible=On}"
    '';
  };

  home-manager.users.elf = {
    home.packages = with pkgs; [ qemu_kvm wineWowPackages.stable vagrant minikube OVMF pkgs.openjdk ];
    services.picom = {
      enable = true;
      backend = "xrender";
    };
    programs.i3status.modules."cpu_temperature 0".settings.path = "/sys/class/hwmon/hwmon0/temp1_input";

    xresources.properties = {
      "Xft.dpi" = 96;
    };
  };


  fileSystems."/efi" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [ "noexec" "nodev" ];
  };
  fileSystems."/run/media/elf/stuff" = {
    device = "/dev/mapper/stuff";
    fsType = "btrfs";
    options = [ "subvol=stuff" "noauto" "compress=zstd" "lazytime" "noexec" "nosuid" "nodev" ];
  };

  fileSystems."/run/media/elf/backup" = {
    device = "/dev/mapper/backup";
    fsType = "btrfs";
    options = [ "subvol=backup" "noauto" "compress=lzo" "lazytime" "noexec" "nosuid" "nodev" ];
  };

  security = {
    allowSimultaneousMultithreading = true;
    lockKernelModules = false;
    allowUserNamespaces = true;
  };

  environment = {
    memoryAllocator.provider = "libc";
    etc."machine-id".text = "231cf24683d645868a965c534d80e403";

    systemPackages = with pkgs; [
      linuxPackages_latest_hardened.perf
      linuxPackages_latest_hardened.bpftrace
    ];
  };

  virtualisation.virtualbox.host = {
    enable = true;
  };

  nix = {
    maxJobs = lib.mkDefault 12;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  programs.steam.enable = true;
}
