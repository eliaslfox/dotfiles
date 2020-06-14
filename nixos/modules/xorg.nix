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
    displayManager.startx.enable = true;
  };

  home-manager.users.elf = {
    home.packages = with pkgs; [ libinput arandr xorg.xprop xorg.xhost xclip ];

    xsession.enable = true;
    xsession.windowManager.i3.enable = true;

    services.unclutter.enable = true;
  };
}
