{  pkgs, ... }:

let
  lowBatteryNotifier = pkgs.writeScript "lowBatteryNotifier"
    ''
      #!/bin/sh
      set -euf -o pipefail

      BAT_PCT=`${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -P -o '[0-9]+(?=%)'`
      BAT_STA=`${pkgs.acpi}/bin/acpi -b | ${pkgs.gnugrep}/bin/grep -P -o '\w+(?=,)'`
      test $BAT_PCT -le 10 && test $BAT_STA = "Discharging" && DISPLAY=:0.0 ${pkgs.libnotify}/bin/notify-send -u critical 'Low Battery' "Battery is at $BAT_PCT%"
    '';

in
{
  services.upower.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[0-5]", RUN+="${pkgs.systemd}/bin/systemctl hibernate"
  '';

  programs.light.enable = true;
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * elf ${lowBatteryNotifier}"
    ];
  };
}
