{
  enable = true;
  enableDefault = false;
  general = {
    colors = true;
    interval = 5;
    output_format = "i3bar";
  };
  modules = {
    "disk /run/media/elf/backup" = {
      position = 1;
      settings = { format = "%avail"; };
    };
    "disk /run/media/elf/stuff" = {
      position = 2;
      settings = { format = "%avail"; };
    };
    "disk /nix/store" = {
      position = 3;
      settings = { format = "%avail"; };
    };
    "run_watch DHCP" = {
      position = 4;
      settings = { pidfile = "/run/dhcpcd*.pid"; };
    };
    "wireless _first_" = {
      position = 5;
      settings = { format_up = "W: (%quality at %essid) %ip"; };
    };
    "ethernet _first_" = {
      position = 6;
      settings = { format_up = "E: %ip (%speed)"; };
    };
    "volume master" = {
      position = 7;
      settings = {
        format = "♪: %volume";
        format_muted = "♪: muted (%volume)";
        device = "pulse";
        mixer = "Master";
        mixer_idx = 0;
      };
    };
    "battery all" = {
      position = 8;
      settings = {
        format = "%status %percentage %remaining";
        format_down = "";
        status_chr = "⚡ CHR";
        status_bat = "⚡ BAT";
        status_full = "☻ FULL";
      };
    };
    "load" = {
      position = 9;
      settings = { format = "%1min"; };
    };
    "cpu_usage" = {
      position = 10;
      settings = {
        max_threshold = 50;
        degraded_threshold = 25;
      };
    };
    "cpu_temperature 0" = {
      position = 11;
      settings = { path = "/sys/class/hwmon/hwmon0/temp1_input"; };
    };
    "tztime local" = {
      position = 12;
      settings = { format = "%Y-%m-%d %H:%M:%S"; };
    };
  };
}
