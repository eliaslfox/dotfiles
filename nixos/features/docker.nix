{ config, lib, pkgs, ... }:

with lib;

let cfg = config.features.docker;
in {
  options.features.docker = {
    enable = mkEnableOption "enable container based virtualisation";
  };
  config = mkMerge [
    (mkIf cfg.enable {
      virtualisation.docker = {
        enable = true;
        package = pkgs.docker-edge;
        autoPrune = {
          enable = true;
          flags = [ "--all" ];
        };
        storageDriver = "zfs";
      };

      home-manager.users.elf = {
        home.packages = with pkgs; [ docker-compose ];
      };
    })
  ];
}
