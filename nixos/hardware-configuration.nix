{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelModules = [ "kvm-amd" "wl" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

    boot.loader = {
      grub = {
        device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S3Z1NB0K824003D";
        enable = true;
        efiSupport = true;
        memtest86.enable = true;
        useOSProber = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
      timeout = null;
    };

    boot.initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" ];

      luks.devices = {
        root = {
          preLVM = true;
          device = "/dev/disk/by-uuid/85e6a10d-6df6-40b8-9357-3fa66ec2ff2f"; 
        };
        stuff = {
          preLVM = true;
          device = "/dev/disk/by-uuid/04c4a351-9e58-41b3-add1-4e3cd2759155";
        };
      };
    };

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    cpu = {
      amd.updateMicrocode = true;
      intel.updateMicrocode = true;
    };
    opengl.driSupport32Bit = true;
  };

  services.xserver = {
    xrandrHeads = [  
      {
        output = "DP-4";
        primary = true;
      }
    ];
  };

  swapDevices = [ { device = "/dev/vg/swap"; } ];

  fileSystems."/" = { 
    device = "/dev/vg/root";
    fsType = "btrfs";
    options = [ "subvol=rootfs" ];
  };

  fileSystems."/boot" = { 
    device = "/dev/disk/by-uuid/1735-CD63";
    fsType = "vfat";
  };

  fileSystems."/run/media/elf/stuff" = { 
    device = "/dev/mapper/stuff";
    fsType = "btrfs"; 
    options = [ "subvol=stuff" "compress=lzo" ];
  };

  fileSystems."/run/media/elf/backup" = { 
    device = "/dev/mapper/backup";
    fsType = "btrfs"; 
    options = [ "subvol=backup" "compress=lzo:6" "noauto" ];
  };

  
  nix.maxJobs = lib.mkDefault 12;
}
