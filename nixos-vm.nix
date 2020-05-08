{ config, pkgs, ... }:
let
  sshKey =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCw29mpjFx6J7oXtje8FzNoRPBnBWzYdxMcPnqcvbkKNsYxQ6SViPgVYytXTgJ0Luw2g1C8sj+wpYRIDVhaZFmUj5Lhu7CpOVkCdAZPZG1PgzML/hgzYIt5Din0y7cTq02URh/JHQD59Yg7+GA3H02QhmdEIOnG6EjQfiMMJZRdnsuNNd7NIX24UNPz0JN9ukQLAaFN9cTVAHCUv7X8yXqUwLev0+nPhePoJoob+1wwgRbmdpsb0vYZETYKSNNRO4WJDp+9dmTtwk6pahGrkuT5kmSRq+YCJ6o/Q5Zw/RpgwgmYd5HFWnp/vhU0k3K2CLjN1nB+cYOY3ZO/ejhfV9SsRA73iF2x9n9N2xzsdzwoc2mNFHZoyfPKbY1y0H3JZgTLedXNxvL54aJLS9zk9V+flIAzsEE2/pocy5vZ2BKrvQdhqHgvWpWKfHU1QVYy2ezEdgclm4lWnkeHA6untmDa/JoiGVPaZGeRsCVykuJ0PE0M6f/HAl4f3zJaVy2ilL/R6HgOWwlPhjfX3yECbY9AW4paZnhwwxj4szMuLyEYfezDNT06z4eTKBzMcTifsp6po5Zxw8jxeW2AAdHuYybhKsRz942rr5siTemR5IhF1I9Ai/DTIKkdj6UPlQtRex+4t1i2dUHfcf9IrS1w1bOwn5AUMYg6tUHl5K3qAzh1pw== yubikey";

in {
  imports = [
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    /etc/nixos/hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  networking = {
    useDHCP = false;
    firewall.enable = false;
    nameservers = [ "8.8.8.8" "8.8.4.4." ];
    interfaces."enp0s2".ipv4 = {
      addresses = [{
        address = "10.0.0.2";
        prefixLength = 24;
      }];
      routes = [
        {
          address = "10.0.0.0";
          prefixLength = 24;
        }
        {
          address = "0.0.0.0";
          prefixLength = 0;
          via = "10.0.0.1";
        }
      ];
    };
  };

  environment = {
    noXlibs = true;
    systemPackages = with pkgs; [
      (neovim.override {
        withPython = false;
        withPython3 = false;
        withRuby = false;
        vimAlias = true;
      })
      htop
      dnsutils
    ];
    etc."bashrc.local".text = ''
      export TERM=xterm-256color
    '';
  };

  services = {
    udisks2.enable = false;
    openssh = {
      enable = true;
      permitRootLogin = "yes";
      passwordAuthentication = false;
      challengeResponseAuthentication = false;
      allowSFTP = false;
    };
  };

  users = {
    mutableUsers = false;

    users = {
      root = {
        password = "root";
        openssh.authorizedKeys.keys = [ sshKey ];
      };
      elf = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [ sshKey ];
      };
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  documentation.enable = false;

  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = false;
  };

  time.timeZone = "US/Pacafic";

  system = {
    stateVersion = "20.03";
    autoUpgrade.enable = true;
  };

  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
  };
}
