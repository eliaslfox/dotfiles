{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.horriblesubsd;

  horriblesubsd = (pkgs.callPackage "${pkgs.fetchFromGitHub {
      owner = "eliaslfox";
      repo = "horriblesubsd";
      rev = "41169d11cc55b5876abe2324108b88e385a8e30b";
      sha256 = "0cl9vp9gqvm9fb6n18873phsx6zsgrih8xkzbgm5n5rmc9vz2aj8";
      }}" { }
  );

in
{
  options.features.horriblesubsd = {
    enable = mkEnableOption "horriblesubs downloader service";
  };

  config = mkIf cfg.enable {
    home-manager.users.elf = {
      home.packages = [ horriblesubsd ];
      systemd.user.services = {
        horriblesubsd = {
          Unit = {
            Description = "Download anime from horriblesubs";
            Wants = [ "horriblesubsd.timer" ];
          };
          Service = { ExecStart = "${horriblesubsd}/bin/horriblesubsd"; };
          Install = { WantedBy = [ "graphical-session.target" ]; };
        };
      };
      systemd.user.timers = {
        horriblesubsd = {
          Unit = { Description = "Download anime from horriblesubs"; };
          Timer = { OnUnitInactiveSec = "15m"; };
          Install = { WantedBy = [ "timers.target" ]; };
        };
      };
    };
  };
}
