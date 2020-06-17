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
    ./features/internet-sharing.nix
    ./features/vm-bridge.nix
    ./features/horriblesubsd.nix

    ./machine.nix
  ];

  boot = {
    plymouth = {
      enable = true;
      theme = "tribar";
    };
  };

  networking = {
    useDHCP = false;
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    firewall = {
      enable = true;
      allowPing = false;
      checkReversePath = "strict";
      logReversePathDrops = true;
    };
    wireless = {
      enable = true;
      networks = credentials.wifi;
      userControlled.enable = true;
    };
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      manpages
      git
      wget
      ncat
      dnsutils

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

    journald.extraConfig = ''
      Storage=volatile
      RuntimeMaxUse=100M
    '';
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
    pulseaudio = {
      enable = true;
      daemon.config = {
        default-sample-rate = 48000;
        alternate-sample-rate = 44410;
        avoid-resampling = true;
      };
      configFile = "${pkgs.callPackage ./modules/pulse.nix { }}/default.pa";
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
    stateVersion = "20.09";
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
      "cudatoolkit"

      "zoom-us"
      "discord"

      "steam"
      "steam-original"
      "steam-runtime"

      "libspotify"
      "pyspotify"

      "broadcom-sta"
    ];
}
