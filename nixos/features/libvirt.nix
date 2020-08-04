{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.libvirt;
in
{
  options.features.libvirt = {
    enable = mkEnableOption "enable libvirt";
  };
  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemuPackage = pkgs.qemu_kvm;
    };
  };
}
