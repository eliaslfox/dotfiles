{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.virtualisation;
in
{
  options.features.virtualisation = {
    enableContainers = mkEnableOption "enable container based virtualisation";
    enableKvm = mkEnableOption "enable kvm based virtualisation";
  };
  config =
    mkMerge [
      (mkIf cfg.enableContainers {
        virtualisation.docker = {
          enable = true;
          package = pkgs.docker-edge;
          autoPrune = {
            enable = true;
            flags = [ "--all" ];
          };
          storageDriver = "zfs";
        };

        home-manager.users.elf ={
          home.packages =
            with pkgs; [
              docker-compose
            ];
        };
      })
    ];
}
