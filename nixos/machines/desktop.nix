{ config, lib, pkgs, ... }:

{
  imports = [
    ../xorg.nix
  ];

  boot = {
    kernelParams = [ "amd_iommu=on" "audit=0"];
    kernelModules = [ "kvm_amd" "wl" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    blacklistedKernelModules = [ "nvidia" ];
    extraModprobeConfig = ''
      options vfio-pci ids=10de:1b80,10de:10f0";
      options kvm ignore_msrs=1
      options kvm_amd nested=1
    '';
    kernelPatches = [
      {
        name = "disable-rds";
        patch = null;
        extraConfig = ''
          RDS n
        '';
      }
    ];

    loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        memtest86.enable = true;
        extraInitrd = "/boot/initrd.keys.gz";
       };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = null;
    };

    plymouth = {
      enable = true;
      theme = "tribar";
    };

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];

      luks.devices = { "root" = {
           preLVM = true;
           device = "/dev/disk/by-uuid/85a66fe9-830b-4944-b0b6-66364ddda85c";
           keyFile = "/keyfile.bin";
        };
        "boot" = {
          preLVM = true;
          device = "/dev/disk/by-uuid/db967c64-6db9-42e9-be89-89f3731e6db3";
    	  keyFile = "/keyfile.bin";
        };
        "stuff" = {
          device = "/dev/disk/by-uuid/04c4a351-9e58-41b3-add1-4e3cd2759155";
          keyFile = "/keyfile.bin";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  features = {
    virtualisation.enable = true;
    horriblesubsd.enable = true;
    hoogle.enable = true;
    openssh.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  home-manager.users.elf = {
    home.packages =
      with pkgs; [
        transmission-gtk
        steam
      ];
    xsession.windowManager.i3.config.bars = [
      {
        trayOutput = "primary";
      }
    ];
  };


  fileSystems."/" =
    { device = "/dev/mapper/vg-root";
      fsType = "btrfs";
      options = [ "subvol=rootfs" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/c0aece9e-50e0-4413-871f-f2378ef2ba8d";
      fsType = "ext4";
    };

  fileSystems."/run/media/elf/stuff" =
    { device = "/dev/mapper/stuff";
      fsType = "btrfs";
      options = ["subvol=stuff"];
    };

  nix = {
    maxJobs = lib.mkDefault 12;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
