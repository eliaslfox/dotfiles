{ config, lib, pkgs, ... }:

{

  imports = [ ../laptop.nix ../xorg.nix ];

  networking.hostName = "nico-ni";
  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [
        "i915" # intel graphics
        "mba6x_bl" # backlight
      ];
    };

    kernelParams = [ "acpi_osi=Darwin" ];
    kernelModules = [ "kvm-intel" "wl" ];
    kernel.sysctl = { "vm.dirty_writeback_centisecs" = 1500; };

    extraModulePackages = with config.boot.kernelPackages; [
      broadcom_sta # broadcom wireless drivers
      mba6x_bl # backlight
    ];

    loader = {
      grub = {
        device = "nodev";
        enable = true;
        efiSupport = true;
        memtest86.enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = null;
    };
  };

  # intel graphics packages
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

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/362c5acb-8440-4d40-9a23-f9df1080fba3";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."enc-root".device =
    "/dev/disk/by-uuid/294cef0a-8a29-4d02-8c72-326e30ab04b5";

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/EC04-533A";
    fsType = "vfat";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/b591147f-2468-43dc-b700-8db57095ba83";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."enc-boot".device =
    "/dev/disk/by-uuid/ff109062-968c-4190-9714-b2ec6a9b5e5d";
  boot.initrd.luks.devices."enc-swap".device =
    "/dev/disk/by-uuid/bcee7a4f-f092-4e2c-af16-6ddc7a43317a";

  swapDevices = [{ device = "/dev/mapper/enc-swap"; }];

  nix.maxJobs = lib.mkDefault 4;

  powerManagement = {
    cpuFreqGovernor = "power-save";
    powertop.enable = true;
    scsiLinkPolicy = "min_power";
  };

  services.thermald.enable = true;
}
