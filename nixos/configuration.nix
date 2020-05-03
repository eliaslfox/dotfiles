{ pkgs, config, lib, ... }:
let credentials = import ./credentials.nix;
in {

  imports = [
    <home-manager/nixos>

    ./scripts.nix
    ./users

    ./features/mopidy.nix
    ./features/docker.nix
    ./features/steam.nix
    ./features/wireguard.nix

    ./machine.nix
  ];

  boot = {
    kernelParams = [
      # Disable ipv6
      "ipv6.disable=1"
    ];

    kernel.sysctl = {
      # Don't forward ipv4 packets
      "net.ipv4.ip_forward" = 0;

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
      enable = false;
      allowedUDPPorts = lib.mkForce [ ];
      allowedTCPPorts = lib.mkForce [ ];
      allowPing = false;
      logReversePathDrops = true;
      logRefusedPackets = true;
    };
    wireguard.enable = true;
    dhcpcd.enable = false;
    /* dhcpcd.extraConfig = ''
         nooption domain_name_servers, domain_name, domain_search, host_name, ntp_servers
       '';
    */
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    configFile = ./dnscrypt-proxy.toml;
  };

  environment = {
    etc = {
      "dnscrypt.pem".source = ./dnscrypt.pem;
      "bashrc.local".text = ''
        export HISTFILE=~/.cache/bash_history
      '';
    };
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      dhcp
      manpages
      iw
      git
      tmux
      gnumake
      wpa_supplicant
      curl
      wget
    ];
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  services.udisks2.enable = false;

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
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
      configFile = "${pkgs.callPackage ./pulse.nix { }}/default.pa";
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

  services.physlock = {
    enable = true;
    allowAnyUser = true;
  };

  documentation = {
    dev.enable = true;
    doc.enable = false;
  };

  security.sudo.extraConfig = ''
    Defaults  lecture="never"
  '';

  time.timeZone = "US/Pacific";

  nix.autoOptimiseStore = true;

  system = {
    stateVersion = "20.03";
    autoUpgrade = {
      enable = true;
      flags = [
        "-I"
        "nixos-config=/home/elf/Documents/dotfiles/nixos/configuration.nix"
      ];
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-settings"
      "nvidia-x11"
      "nvidia-persistenced"

      "discord"

      "steam"
      "steam-original"
      "steam-runtime"

      "zoom-us"
    ];
}
