{ pkgs, config, lib, ... }:
let
  credentials = import ./credentials.nix;
in
{

  imports = [
    "${builtins.fetchGit {
        url = https://github.com/rycee/home-manager;
        ref = "master";
      }}/nixos"

    ./scripts.nix
    ./users

    ./features/hoogle.nix
    ./features/horriblesubsd.nix
    ./features/mopidy.nix
    ./features/virtualisation.nix
    ./features/vpn.nix
    ./features/openssh.nix
    ./features/tor.nix
    ./features/iptables-notify.nix

    ./machine.nix
  ];

  boot = {
    /* gotta go fast */
    kernelParams = [ "audit=0" "ipv6.disable=1" ];

    kernel.sysctl = {
      /* Don't forward ipv4 packets */
      "net.ipv4.ip_forward" = 0; /* Swap to disk less */
      "vm.swappiness" = 1;

      /* Disable ipv6 */
      "net.ipv6.conf.all.disable_ipv6" = 1;
      "net.ipv6.conf.default.disable_ipv6" = 1;
      "net.ipv6.conf.lo.disable_ipv6" = 1;
    };

    plymouth = {
      enable = true;
      theme = "tribar";
    };
  };

  networking = {
    /* nameservers = ["8.8.8.8" "8.8.4.4"]; */
    nameservers = [ "209.222.18.222" "209.222.18.218" ];
    enableIPv6 = false;
    firewall = {
      enable = true;
      allowedUDPPorts = lib.mkForce [];
      allowedTCPPorts = lib.mkForce [];
      allowPing = false;
      logReversePathDrops = true;
    };
    /*
    wireless = {
      enable = true;
      networks = credentials.wifi;
      interfaces = [ "wlp6s0" ];
      extraConfig = ''
        country=US
      '';
    };
    */
    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = false;
      insertNameservers = [ "209.222.18.222" "209.222.18.218" ];
    };
  };

  features = {
    iptables-notify.enable = true;
    vpn = {
      enable = true;
      credentials = credentials.vpn;
    };
    mopidy = {
      enable = true;
      credentials = credentials.spotify;
    };
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages =
    with pkgs; [
      iw
      iptables
      git
      tmux
      gnumake
      wpa_supplicant
      vim
      curl wget
      docker-compose
    ];

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    fontconfig = {
      defaultFonts = {
        monospace = ["Fira Code Light"];
      };
      /*
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
      */
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
      support32Bit = true;
      daemon.config = {
        default-sample-rate = 44100;
        alternate-sample-rate = 48000;
      };
    };
    cpu = {
      amd.updateMicrocode = true;
      intel.updateMicrocode = true;
    };
  };

  zramSwap= {
    enable = true;
    algorithm = "zstd";
  };

  documentation = {
    dev.enable = true;
    nixos.enable = true;
    doc.enable = false;
  };

  programs.iotop.enable = true;
  programs.dconf.enable = true;
  programs.wireshark.enable = true;

  services.udisks2.enable = false;
  services.physlock = {
    enable = true;
    allowAnyUser = true;
  };

  time.timeZone = "US/Pacific";

  system.autoUpgrade.enable = true;
  nix.optimise.automatic = true;
  system.stateVersion = "19.03";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-settings"
    "nvidia-x11"
    "nvidia-persistenced"

    "discord"
  ];
}
