{ pkgs, ... }:
let
  credentials = import ./credentials.nix;
in
{

  imports = [
    "${builtins.fetchGit {
    	url = https://github.com/rycee/home-manager;
    	ref = "master";
      }}/nixos"

    ./mounts.nix
    ./scripts.nix
    ./users

    ./features/hoogle.nix
    ./features/horriblesubsd.nix
    ./features/mopidy.nix
    ./features/virtualisation.nix
    ./features/vpn.nix
    ./features/openssh.nix

    ./machine.nix
  ];

  networking = {
    nameservers = ["8.8.8.8" "8.8.4.4"];
    enableIPv6 = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
      allowPing = false;
    };
    wireless = {
      enable = true;
      networks = {
        "${credentials.wifi.name}" = {
          psk = credentials.wifi.psk;
        };
      };
    };
  };

  features = {
    vpn = {
      enable = true;
      credentials = credentials.vpn;
    };
    mopidy = {
      enable = true;
      credentials = credentials.spotify;
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages =
    with pkgs; [
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
    opengl.driSupport32Bit = true;
  };

  zramSwap= {
    enable = true;
    algorithm = "zstd";
  };

  documentation.dev.enable = true;

  programs.iotop.enable = true;
  programs.dconf.enable = true;

  services.udisks2.enable = false;
  services.pcscd.enable = true;
  services.physlock = {
    enable = true;
    allowAnyUser = true;
  };

  time.timeZone = "US/Pacific";
  system.autoUpgrade.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix = {
    optimise.automatic = true;
  };
  system.stateVersion = "19.03";
}
