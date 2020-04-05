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
        };

        users.extraUsers.elf.extraGroups = [ "docker" ];

        home-manager.users.elf ={
          home.packages =
            with pkgs; [
              docker-compose
            ];
        };

      })

      (mkIf cfg.enableKvm {
        virtualisation.libvirtd = {
          enable = true;
          onShutdown = "shutdown";
          qemuPackage = pkgs.qemu_kvm;
          qemuVerbatimConfig = ''
            user = "elf"
          '';
        };

        users.extraUsers.elf.extraGroups = [ "libvirtd" ];

        home-manager.users.elf ={
          home.packages =
            with pkgs; [
              qemu_kvm
              virtmanager
            ];
        };
      })
    ];
}
