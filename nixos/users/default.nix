{ pkgs, config, lib, ... }:

{
  users.mutableUsers = false;
  users.extraUsers.elf = {
    isNormalUser = true;
    home = "/home/elf";
    description = "Elias Lawson-Fox";
    extraGroups = [ "wheel" "video" "sound" ];
    uid = 1000;
    shell = pkgs.zsh;
    passwordFile = "/etc/nixos/passwords/elf";
  };
  users.extraUsers.root = {
    passwordFile = "/etc/nixos/passwords/root";
  };
  home-manager.users.elf = import ./elf { config = config; pkgs = pkgs; };
}
