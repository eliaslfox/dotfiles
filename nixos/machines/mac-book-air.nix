{ config, lib, pkgs, ... }:

{

  imports = [
    ../laptop.nix
  ];
  networking.hostName = "nico-ni";
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 0;
  };

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
  programs.sway.enable = true;

  home-manager.users.elf.xsession.windowManager.i3.config.startup = [
    {
      command = "${pkgs.dunst}/bin/dunst";
      always = true;
    }
  ];
  home-manager.users.elf.home.packages = [ pkgs.firefox-wayland ];

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
