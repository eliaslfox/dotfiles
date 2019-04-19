{ pkgs, config, lib, ... }:

{
  users.extraUsers.elf = {
    isNormalUser = true;
    home = "/home/elf";
    description = "Elias Lawson-Fox";
    extraGroups = [ "wheel" "video" "sound" "docker" "libvirtd" ];
    uid = 1000;
    shell = pkgs.zsh;
  };
  home-manager.users.elf = import ./elf { config = config; pkgs = pkgs; };
}
