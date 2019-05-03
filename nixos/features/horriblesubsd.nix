with import <nixpkgs> {};
{ config, lib, pkgs, ... }:

with lib;

let 
  cfg = config.features.horriblesubsd;
  
  horriblesubsd =
    (callPackage "${fetchFromGitHub {
      owner = "eliaslfox";
      repo = "horriblesubsd";
      rev = "490a1be19eb3a1d7a7fe04b70c099d41b143bf47";
      sha256 = "0x8szf1rhhzsacp69874wy3cgr7i1h7dxv3nfpkjqy2914hsszbg";
    }}" {});
in
{
  options.features.horriblesubsd = {
    enable = mkEnableOption "horriblesubs downloader service";
  };

  config = mkIf cfg.enable {
    home-manager.users.elf = {
      systemd.user.services = {
        horriblesubsd = {
          Unit = {
            Description = "Download anime from horriblesubs";
            Wants = [ "horriblesubsd.timer" ];
          };
          Service = {
            ExecStart = "${horriblesubsd}/bin/horriblesubsd";
          };
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };
      };
      systemd.user.timers = {
        horriblesubsd = {
          Unit = {
            Description = "Download anime from horriblesubs";
          };
          Timer = {
            OnUnitInactiveSec = "15m";
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
        };
      };
    };
  };
}
