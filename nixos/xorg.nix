{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      tapping = true;
      disableWhileTyping = true;
      sendEventsMode = "disabled-on-external-mouse";
      accelSpeed = "1.75";
    };
    desktopManager = {
      xterm.enable = false;
    };
    displayManager.lightdm = {
      enable = true;
    };
  };
  services.autorandr.enable = true;

  home-manager.users.elf = {
    home.packages =
      with pkgs; [
        libinput
        arandr
      ];

    xsession.enable = true;
    xsession.windowManager.i3.enable = true;

    services.unclutter.enable = true;
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
