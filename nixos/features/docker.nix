{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.features.docker;
in
{
  options.features.docker = {
    enable = mkEnableOption "enable container based virtualisation";
  };
  config = mkIf cfg.enable {
    home-manager.users.elf = {
      home.packages = with pkgs; [ podman-compose ];
    };
    virtualisation = {
      podman = {
        enable = true;
      };
    };
  };
}
