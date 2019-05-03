{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.virtualisation;
in
{
  options.features.virtualisation = {
    enable = mkEnableOption "enable virtualisation tools";
  };
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      package = pkgs.docker-edge;
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
      };
    };

    virtualisation.libvirtd = {
      enable = true;
      onShutdown = "shutdown";
    };

    users.extraUsers.elf.extraGroups = [ "docker" "libvirtd" ];

    home-manager.users.elf = {
      home.packages =
        with pkgs; [
          qemu
          wine
          virtmanager
        ];
    };
  };
}
