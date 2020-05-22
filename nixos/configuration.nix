{ pkgs, config, lib, ... }:
let
  credentials = pkgs.callPackage ./credentials.nix { };
  scripts = pkgs.callPackage ./scripts.nix { };
in
{

  imports = [
    <home-manager/nixos>
    ../nix-modules

    ./users

    ./features/mopidy.nix
    ./features/docker.nix
    ./features/steam.nix
    ./features/dnscrypt.nix
    ./features/internet-sharing.nix
    ./features/vm-bridge.nix
    ./features/horriblesubsd.nix

    ./machine.nix
  ];

  boot = {
    kernelParams = [
      # Disable ipv6
      "ipv6.disable=1"
    ];

    kernel.sysctl = {
      # Swap to disk less
      "vm.swappiness" = 1;

      # Disable ipv6
      "net.ipv6.conf.all.disable_ipv6" = 1;
      "net.ipv6.conf.default.disable_ipv6" = 1;
      "net.ipv6.conf.lo.disable_ipv6" = 1;
    };

    extraModprobeConfig = ''
      # Disable overlayfs
      blacklist overlayfs
      install overlayfs ${pkgs.coreutils}/bin/false
    '';

    plymouth = {
      enable = true;
      theme = "tribar";
    };
  };

  networking = {
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    enableIPv6 = false;
    firewall = {
      enable = true;
      allowPing = false;
      allowedUDPPorts = [ ];
      allowedTCPPorts = [ ];
    };
    wireless = {
      enable = true;
      networks = credentials.wifi;
    };
  };

  environment = {
    etc = {
      "bashrc.local".text = ''
        export HISTFILE=~/.cache/bash_history
      '';
    };
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      manpages
      git
      wget
      ncat

      psmisc
      pciutils
      usbutils

      scripts.iommuGroups
      scripts.mountBackup
      scripts.physexec
    ];
  };

  services = {
    udev.packages = [ pkgs.yubikey-personalization ];
    pcscd.enable = true;

    udisks2.enable = false;

    physlock = {
      enable = true;
      allowAnyUser = true;
    };
  };

  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = { monospace = [ "Fira Code Light" ]; };
      localConf = ''
        <fontconfig>
        <match>
          <test name="family">
            <string>Helvetica</string>
          </test>
          <edit binding="same" mode="assign" name="family">
            <string>Source Sans Pro</string>
          </edit>
        </match>
        <match>
          <test name="family">
            <string>Arial</string>
          </test>
          <edit binding="same" mode="assign" name="family">
            <string>Source Sans Pro</string>
          </edit>
        </match>
        </fontconfig>
      '';
      hinting.autohint = true;
      includeUserConf = false;
    };
    fonts = with pkgs; [
      # Base Fonts
      source-sans-pro
      source-serif-pro

      # Programming
      powerline-fonts
      fira-code
      fira-code-symbols

      # Emoji
      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
    ];
  };

  hardware = {
    u2f.enable = true;
    pulseaudio = {
      enable = true;
      daemon.config = {
        default-sample-rate = 44100;
        alternate-sample-rate = 48000;
      };
      configFile = "${pkgs.callPackage ./modules/pulse.nix { }}/default.pa";
    };
    cpu = {
      amd.updateMicrocode = true;
      intel.updateMicrocode = true;
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  programs.iotop.enable = true;
  programs.dconf.enable = true;
  programs.wireshark.enable = true;

  documentation = {
    dev.enable = true;
    doc.enable = false;
  };

  security.sudo = {
    extraConfig = ''
      Defaults  lecture="never"
    '';
  };
  security.wrappers = {
    elf-i3status = {
      source = "${scripts.elf-i3status}/bin/elf-i3status";
      capabilities = "cap_sys_admin+ep";
    };
    wg-status = {
      source = "${scripts.wg-status}/bin/wg-status";
      capabilities = "cap_net_admin+ep";
    };
  };

  time.timeZone = "US/Pacific";

  system = {
    stateVersion = "20.03";
    autoUpgrade = { enable = true; };
  };

  nix = {
    autoOptimiseStore = true;
    gc = { automatic = true; };
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/home/elf/Documents/dotfiles/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-settings"
      "nvidia-x11"
      "nvidia-persistenced"

      "discord"

      "libspotify"
      "pyspotify"
    ];
}
