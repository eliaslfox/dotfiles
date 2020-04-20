{ config, lib, ... }:

with lib;

let
  cfg = config.features.tftpd;
in
{
  options.features.tftpd = {
    enable = mkEnableOption "enable tftpd daemon";
  };

  config = mkIf cfg.enable {
    /*
    services.xinetd.enable = true;

    services.tftpd = {
      enable = true;
      path = "/tmp/tftp";
    };
    */

    services.atftpd = {
      enable = true;
      root = "/tmp/tftp";
    };
  };
}
