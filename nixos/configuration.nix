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

    ./features/docker.nix
    ./features/steam.nix
    ./features/horriblesubsd.nix
    ./features/printing.nix

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
    };
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    etc = {
      "u2f-mappings".text = credentials.u2f;
    };
    systemPackages = with pkgs; [
      manpages
      git
      wget
      ncat
      dnsutils
      inetutils
      file

      psmisc
      pciutils
      usbutils

      scripts.iommuGroups
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

    fstrim.enable = true;
  };

  fonts = {
    enableDefaultFonts = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      defaultFonts = { monospace = [ "Fira Code Light" ]; };
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

      # settings to improve passthrough audio from a vm
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
  systemd.services."zram-reloader" = {
    restartIfChanged = lib.mkForce false;
  };

  programs.iotop.enable = true;
  programs.dconf.enable = true;
  programs.wireshark.enable = true;

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
  };

  security.sudo = {
    extraConfig = ''
      Defaults  lecture="never"
    '';
  };
  security = {
    pam = {
      u2f = {
        enable = true;
        authFile = "/etc/u2f-mappings";
      };
    };
    wrappers = {
      elf-i3status = {
        source = "${scripts.elf-i3status}/bin/elf-i3status";
        capabilities = "cap_sys_admin+ep";
      };
    };
  };

  time.timeZone = "US/Pacific";

  system = {
    stateVersion = "21.05";
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

      "discord"
      "zoom-us"
      "zoom"
      "faac"
      "spotify"
      "spotify-unwrapped"

      "steam"
      "steam-original"
      "steam-runtime"

      "broadcom-sta"
    ];
}
