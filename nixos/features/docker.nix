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
    environment.etc."containers/storage.conf".text = ''
      [storage]
      driver="zfs"

      [storage.options.zfs]
      mountopt="nodev"
    '';
  };
}
