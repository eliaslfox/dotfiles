with import <nixpkgs> { };
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.horriblesubsd;

  horriblesubsd = (callPackage "${fetchFromGitHub {
    owner = "eliaslfox";
    repo = "horriblesubsd";
    rev = "2c7ccdbbc93bfe8129362e7213ef8c9d0b4be4df";
    sha256 = "1vflxz40siffnjvvd2fndgxnhpcbqfg3al846jm35zj7ra5krlc4";
  }}" { });

in {
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
