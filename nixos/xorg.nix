{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      naturalScrolling = false;
      tapping = true;
    };
    desktopManager.xterm.enable = false;
    desktopManager.default = "none";
    displayManager.slim = {
      defaultUser = "elf";
      enable = true;
      theme = pkgs.fetchurl {
          url = "https://github.com/edwtjo/nixos-black-theme/archive/v1.0.tar.gz";
          sha256 = "13bm7k3p6k7yq47nba08bn48cfv536k4ipnwwp1q1l2ydlp85r9d";
        };
      };
    };
    services.autorandr.enable = true;

    home-manager.users.elf = {
      home.packages =
        with pkgs; [
          arandr
        ];

      xsession.enable = true;
      xsession.windowManager.i3.enable = true;

      services.unclutter.enable = true;
      services.compton.enable = true;
      services.random-background = {
        enable = true;
        imageDirectory = "%h/Documents/backgrounds";
      };
      services.screen-locker = {
        enable = true;
        inactiveInterval = 10;
        lockCmd = "/run/wrappers/bin/physlock";
      };
  };
}
