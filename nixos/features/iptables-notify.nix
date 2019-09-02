{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.iptables-notify;

  iptables-notify =
      (pkgs.callPackage "${pkgs.fetchFromGitHub {
        owner = "eliaslfox";
        repo = "iptables-notify";
        rev = "6c2d7ccf70c38fb900cebe310dda3dcbc3f153fe";
        sha256 = "1jpq1bc9bdv834w9ja4dyba158382y4qk0ij29fphqfl7kp494aw";
      }}" {});
in
{
  options.features.iptables-notify = {
    enable = mkEnableOption "iptables notify service";
  };

  config = mkIf cfg.enable {
    home-manager.users.elf = {
      home.packages = [
        iptables-notify
      ];

      systemd.user.services = {
        iptables-notify = {
          Unit = {
            Description = "Iptables notify service";
          };
          Service = {
            ExecStart = "${iptables-notify}/bin/iptables-notify";
          };
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };
      };
    };
  };
}
