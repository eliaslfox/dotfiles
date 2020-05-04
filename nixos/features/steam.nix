{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.features.steam;
in {
  options.features.steam = { enable = mkEnableOption "steam"; };

  config = mkIf cfg.enable {
    hardware = {
      opengl = {
        driSupport32Bit = true;
        extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      };
      pulseaudio.support32Bit = true;
    };
  };
}
