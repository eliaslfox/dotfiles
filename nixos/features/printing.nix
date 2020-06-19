{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.features.printing;

in
{
  options.features.printing = { enable = mkEnableOption "printing"; };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        brlaser
      ];
    };

    programs.system-config-printer.enable = true;
  };
}
