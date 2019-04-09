{ pkgs, config, lib, ... }:

{
  users.extraUsers.elf = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "sound" "docker" ];
    createHome = true;
  };
  home-manager.users.elf = import ./elf { config = config; pkgs = pkgs; };
}
