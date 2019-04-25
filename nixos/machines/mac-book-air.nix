{ config, lib, pkgs, ... }:

{

  networking.hostName = "nico-ni";
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  boot.loader = {
    grub = {
      device = "/dev/sda";
      enable = true;
      efiSupport = true;
      memtest86.enable = true;
    };
    efi.canTouchEfiVariables = true;
    timeout = null;
  };

  services.xserver.videoDrivers = [ "intel" ];
  home-manager.users.elf.xsession.windowManager.i3.config.bars = [
    { trayOutput = "eDPI-1"; }
  ];

  boot.initrd.luks.devices.root = {
    preLVM = true;
    device = "/dev/sda3";
  };

  fileSystems."/" =
    { device = "/dev/vg/root";
      fsType = "btrfs";
      options = [ "subvol=rootfs" ];
    };

  fileSystems."/boot" =
    { device = "/dev/sda2";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/vg/swap"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
