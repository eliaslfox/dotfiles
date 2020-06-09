with import <nixpkgs> { }; {
  enable = true;
  iconTheme = {
    package = pkgs.gnome-themes-extra;
    name = "Adwaita";
  };
  settings = {
    global = {
      font = "FiraCode 9";
      geometry = "300x5-30+30";
      transparency = 20;
      monitor = 0;
      follow = "none";
      sticky_history = "yes";
      line_height = 0;
      seperator_height = 2;
      padding = 10;
      horizontal_padding = 10;
      separator_color = "frame";
      icon_position = "left";
      word_wrap = "yes";
      max_icon_size = 32;
      format = "<b>%s</b><br />\\n%b";
      markup = "full";
      show_indicators = "no";
      browser = "${pkgs.firefox}/bin/firefox -new-tab";
      dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst";
    };
    frame = {
      width = 0;
      color = "#000000";
    };
    urgency_low = {
      background = "#333333";
      foreground = "#ffffff";
      timeout = 10;
    };
    urgency_normal = {
      background = "#333333";
      foreground = "#ffffff";
      timeout = 10;
    };
    urgency_critical = {
      background = "#333333";
      foreground = "#ffffff";
      timeout = 10;
    };
  };
}
