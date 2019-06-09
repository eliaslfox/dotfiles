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

    kernelModules = [ "kvm-intel" "wl" ];

    /*
     * should reduce power consumption
     * https://github.com/NixOS/nixos-hardware/blob/master/apple/macbook-air/6/default.nix#L10-L11
     */
    kernelParams = [ "acpi_osi=" ];

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
  powerManagement.cpuFreqGovernor = null;
  services.tlp.enable = true;
}
