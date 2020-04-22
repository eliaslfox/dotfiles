{ config, lib, pkgs, ... }:

let
  scripts = pkgs.callPackage (import ../users/elf/scripts.nix) {};
in
{ imports = [
    <nixpkgs/nixos/modules/profiles/hardened.nix>
    ../xorg.nix
    ../mounts-zfs.nix
  ];

  boot = {
    kernelModules = [ "kvm_amd" ];
    extraModprobeConfig = ''
      options iwlwifi 11n_disable=1
    '';

    kernel.sysctl = {
      /* Enable packet forwarding on these interfaces for internet sharing */
      "net.ipv4.conf.enp4s0.forwarding" = 1;
      "net.ipv4.conf.tun0.forwarding" = 1;
    };

    loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
       };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 10;
    };

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      luks.devices.root.device = "/dev/disk/by-uuid/edc067ee-6d0a-445e-a05a-28f25c2409dd";
      luks.devices.stuff.device = "/dev/disk/by-uuid/04c4a351-9e58-41b3-add1-4e3cd2759155";
    };
  };

  features = {
    virtualisation = {
      enableContainers = true;
      enableKvm = false;
    };
    horriblesubsd.enable = true;
    tftpd.enable = false;
  };

  hardware = {
    enableRedistributableFirmware = true;
  };

  networking = {
    hostName = "darling";
    hostId = "8425e349";
    wireless.interfaces = [ "wlp6s0" ];
    dhcpcd.allowInterfaces = [ "wlp6s0" ];
    firewall.extraCommands = ''
      # NAT forward enp4s0 to tun0
      iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
      iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
      iptables -A FORWARD -i enp4s0 -o tun0 -j ACCEPT

      # Allow DHCP and DNS requests over ethernet
      iptables -I INPUT -p udp --dport 67 -i enp4s0 -j ACCEPT
      iptables -I INPUT -p udp --dport 53 -i enp4s0 -j ACCEPT
      iptables -I INPUT -p tcp --dport 53 -i enp4s0 -j ACCEPT


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
      option domain-name-servers 192.168.100.1;

      subnet 192.168.100.0 netmask 255.255.255.0 {
        range 192.168.100.100 192.168.100.200;
      }
    '';
    interfaces = [ "enp4s0" ];
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xrandrHeads = [
      {
        output = "DP-5";
      }
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
    home.packages =
      with pkgs; [
        wineFull
        cura
        printrun
        qemu_kvm
      ];
    services.picom.enable = true;
  };

  fileSystems."/efi" =
    { device = "/dev/nvme0n1p1";
      fsType = "vfat";
      options = [ "ro" "noexec" ];
    };

  fileSystems."/boot" =
    { device = "/dev/nvme0n1p2";
      fsType = "ext4";
      options = [ "ro" "noexec" ];
    };

  fileSystems."/run/media/elf/stuff" =
    { device = "/dev/mapper/stuff";
      fsType = "btrfs";
      options = ["subvol=stuff" "compress=zstd" "noexec" ];
    };

  fileSystems."/run/media/elf/backup" =
  { device = "/dev/mapper/backup";
    fsType = "btrfs";
    options = [ "subvol=backup" "noauto" "compress=lzo" "noexec"];
  };

  services.zfs = {
    autoScrub = {
      enable = true;
      pools = [ "zroot" ];
    };
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };

  security.allowSimultaneousMultithreading = true;
  security.virtualisation.flushL1DataCache = lib.mkForce null;
  security.lockKernelModules = false;
  security.allowUserNamespaces = true;


  nix = {
    maxJobs = lib.mkDefault 12;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
