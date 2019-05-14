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
    nameservers = ["1.1.1.1" "1.0.0.1"];
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
    ];

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    fontconfig = {
      defaultFonts = {
        monospace = ["Fira Code Light"];
      };
    };
    fonts = with pkgs; [
      powerline-fonts
      fira-code
      fira-code-symbols

      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
    ];
  };

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
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
  services.pcscd.enable = true;
  services.physlock.enable = true;

  time.timeZone = "US/Pacific";
  system.autoUpgrade.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc.automatic = true;
    optimise.automatic = true;
  };
  system.stateVersion = "19.03";
}
