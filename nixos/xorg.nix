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
    desktopManager.xterm.enable = true;
    displayManager.lightdm = {
      enable = true;
    };
    displayManager.defaultSession = "xterm";
  };

  home-manager.users.elf = {
    home.packages =
      with pkgs; [
        libinput
        arandr
      ];

    xsession.enable = true;
    xsession.windowManager.i3.enable = true;

    services.unclutter.enable = true;
    services.screen-locker = {
      enable = true;
      inactiveInterval = 20;
      lockCmd = "/run/wrappers/bin/physlock";
    };
  };
}
