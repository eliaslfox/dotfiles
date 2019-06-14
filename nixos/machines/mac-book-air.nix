{ config, lib, pkgs, ... }:

{

  imports = [
    ../laptop.nix
    ../mounts-btrfs.nix
    ../xorg.nix
  ];

  networking.hostName = "nico-ni";
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [
        "i915" /* intel graphics */
        "mba6x_bl" /* backlight */
      ];
    };

    kernelParams = [ "acpi_osi=Darwin" ];
    kernelModules = [ "kvm-intel" "wl" ];
    kernel.sysctl = {
      "vm.dirty_writeback_centisecs" = 1500;
    };

    extraModulePackages =
      with config.boot.kernelPackages; [
        broadcom_sta /* broadcom wireless drivers */
        mba6x_bl /* backlight */
      ];

    loader = {
      grub = {
        device = "/dev/sda";
        enable = true;
        efiSupport = true;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = null;
    };
  };

  /* intel graphics packages */
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];

  services.xserver = {
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "Backlight" "mba6x_backlight"
      Option "TearFree" "true"
    '';
  };

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

  /* use tlp for power managment */
  powerManagement = {
    cpuFreqGovernor = "power-save";
    powertop.enable = true;
    scsiLinkPolicy = "med_power_with_dipm";
  };

  services.thermald.enable = true;
  /*
  services.tlp = {
    enable = true;
    extraConfig = ''
      SATA_LINKPWR_ON_AC="
      SATA_LINKPWR_ON_BAT="med_power_with_dipm max_performance"
      MAX_LOST_WORK_SECS_ON_AC=15
      MAX_LOST_WORK_SECS_ON_BAT=15
    '';
  };
  */
}
