{ pkgs, ... }:
{
  boot.kernel.sysctl = {
    # Swap to disk less
    "vm.swappiness" = 1;
  };

  services.upower = {
    enable = true;
    percentageAction = 5;
    percentageCritical = 7;
  };

  programs.light.enable = true;
}
