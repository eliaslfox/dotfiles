{ config, pkgs, ... }:
let
  lowBatteryNotifier = pkgs.writeScript "lowBatteryNotifier"
    ''
      #!/bin/sh
      set -euf -o pipefail

      BAT_PCT=`${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -P -o '[0-9]+(?=%)'`
      BAT_STA=`${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -P -o '\w+(?=,)'`
      test $BAT_PCT -le 10 && test $BAT_STA = "Discharging" && DISPLAY=:0.0 ${pkgs.libnotify}/bin/notify-send -u critical -i ~/icons/low-battery.png 'Low Battery' "Battery is at $BAT_PCT%"
    '';

in 
{
  imports =
    [ 
      "${builtins.fetchGit {
	url = https://github.com/rycee/home-manager;
	ref = "release-18.09";
      }}/nixos"

      ./hardware-configuration.nix
      ./mounts.nix
      ./users
      ./networking.nix
      ./services.nix
      ./scripts.nix
    ];

  environment.systemPackages = 
    with pkgs; [
      git
      tmux
      wpa_supplicant
      neovim
      gnumake
      nethogs
    ];
  environment.pathsToLink = [ "/share/zsh" ];

  time.timeZone = "US/Pacific";

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      defaultFonts = {
        monospace = ["Fira Code Light"];
      };
    };
    fonts = with pkgs; [
      powerline-fonts
      fira-code
      fira-code-symbols
      emojione
    ];
  };

  services.xserver = {
    enable = true;

    videoDrivers = [ "nvidia" ];

    windowManager.i3 = {
      enable = true;
    };

    displayManager.lightdm = {
      enable = true;
      greeters.gtk.enable = true;
    };

    windowManager.default = "i3";

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };
  };

  services.upower.enable = true;
  services.dbus.packages = with pkgs; [ gnome3.dconf ];
  services.udev = {
    packages = with pkgs; [
      yubikey-personalization
    ];
  };
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * elf ${lowBatteryNotifier}"
    ];
  };
  services.physlock = {
    enable = true;
    allowAnyUser = true;
  };

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker-edge;
  };
  
  systemd.services = {
    openvpn-reconnect = {
      description = "Restart OpenVPN after suspend";
      script = "${pkgs.procps}/bin/pkill --signal SIGHUP --exact openvpn";
      wantedBy = ["sleep.target"];
    };
  };

  system.stateVersion = "19.03";
  system.autoUpgrade.enable = true;
  nixpkgs.config.allowUnfree = true;
}
