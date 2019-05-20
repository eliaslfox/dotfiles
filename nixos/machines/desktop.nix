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

      luks.devices = {
        "root" = {
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

  features = {
    virtualisation.enable = true;
    horriblesubsd.enable = true;
    hoogle.enable = true;
    openssh.enable = true;
  };

  networking = {
    firewall.extraCommands = ''
      # NAT forward enp4s0 to tun0
      iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
      iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
      iptables -A FORWARD -i enp4s0 -o tun0 -j ACCEPT

      # Allow DHCP requests over ethernet
      iptables -I INPUT -p udp --dport 67 -i enp4s0 -j ACCEPT
    '';
    interfaces."enp4s0".ipv4.addresses = [
      { address = "192.168.100.1"; prefixLength = 24; }
    ];
  };

  services.dhcpd4 = {
    enable = true;
    extraConfig = ''
      option subnet-mask 255.255.255.0;
      option broadcast-address 192.168.100.255;
      option routers 192.168.100.1;
      option domain-name-servers 1.1.1.1, 1.0.0.1;

      subnet 192.168.100.0 netmask 255.255.255.0 {
        range 192.168.100.100 192.168.100.200;
      }
    '';
    interfaces = [ "enp4s0" ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  home-manager.users.elf = {
    home.packages =
      with pkgs; [
        transmission-gtk
        steam
      ];
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

  fileSystems."/run/media/elf/backup" =
  { device = "/dev/mapper/backup";
    fsType = "btrfs";
    options = [ "subvol=backup" "noauto" "compress=lzo"];
  };

  nix = {
    maxJobs = lib.mkDefault 12;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
