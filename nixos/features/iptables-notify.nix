{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.features.iptables-notify;

  iptables-notify = (pkgs.callPackage "${pkgs.fetchFromGitHub {
    owner = "eliaslfox";
    repo = "iptables-notify";
    rev = "254c79e69a374da0bc2da150df4dcede2d7526ed";
    sha256 = "15a3h4bn7339hgxp8k245n4lk64b9cs5s01mnr9sjx4zkqnvy1lg";
  }}" { });
in {
  options.features.iptables-notify = {
    enable = mkEnableOption "iptables notify service";
  };

  config = mkIf cfg.enable {
    home-manager.users.elf = {
      home.packages = [ iptables-notify ];

      systemd.user.services = {
        iptables-notify = {
          Unit = { Description = "Iptables notify service"; };
          Service = { ExecStart = "${iptables-notify}/bin/iptables-notify"; };
          Install = { WantedBy = [ "graphical-session.target" ]; };
        };
      };
    };
  };
}
