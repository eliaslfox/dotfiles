with import <nixpkgs> {};
{ config, lib, pkgs, ... }:

let
  horriblesubsd =
    (callPackage "${builtins.fetchGit {
      url = "https://github.com/eliaslfox/horriblesubsd";
      ref = "490a1be19eb3a1d7a7fe04b70c099d41b143bf47";
    }}" {});
in
{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

    networking.hostName = "darling";
    boot.kernelParams = [ "amd_iommu=on" ];
    boot.kernelModules = [ "kvm_amd" "wl" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
    boot.blacklistedKernelModules = [ "nvidia" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    boot.extraModprobeConfig = ''
      options vfio-pci ids=10de:1b80,10de:10f0";
      options kvm ignore_msrs=1
    '';

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

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.lightdm.enable = true;
  home-manager.users.elf = {
    xsession.enable = true;
    xsession.windowManager.i3.config.bars = [
      { trayOutput = "HDMI-0"; fonts = ["FiraCode 8"]; }
    ];
    home.packages =
      with pkgs; [
	virtmanager
	arandr
	transmission-gtk
	qemu
	steam
	wine
	nvtop
      ];

    systemd.user.services = {
      horriblesubsd = {
          Unit = {
            Description = "Download anime from horriblesubs";
            Wants = [ "horriblesubsd.timer" ];
          };
          Service = {
            ExecStart = "${horriblesubsd}/bin/horriblesubsd";
          };
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };
      };
      systemd.user.timers = {
        horriblesubsd = {
          Unit = {
            Description = "Download anime from horriblesubs";
          };
          Timer = {
            OnUnitInactiveSec = "15m";
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
        };
      };
  };

  virtualisation.libvirtd = {
    enable = true;
  };


  services.xserver.xrandrHeads =
    [
      {
        output = "HDMI-0";
        primary = true;
      }
    ];

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
