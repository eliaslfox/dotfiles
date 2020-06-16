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
    kernelParams = [ "iommu=pt" ];
    extraModprobeConfig = ''
      options iwlwifi 11n_disable=1

      options vfio-pci ids=10de:1c81,10de:0fb9
      blacklist nouveau
      softdep nvidia pre: vfio-pci
      softdep nvidia* pre: vfio-pci
    '';

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
      timeout = 0;
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
      cache.enable = false;
    };
    vm-bridge.enable = false;
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
    home.packages = with pkgs; [ qemu_kvm minikube OVMF openjdk8 ];
    services.picom = {
      enable = true;
      backend = "xrender";
    };
    programs.i3status.modules."cpu_temperature 0".settings.path = "/sys/class/hwmon/hwmon0/temp1_input";
    services.dunst.enable = true;
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
  };

  nix = {
    maxJobs = lib.mkDefault 12;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  powerManagement.cpuFreqGovernor = "ondemand";
}
