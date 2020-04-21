{ pkgs, config, lib, ... }:

let
  credentials = import ../credentials.nix;
in

{
  users.mutableUsers = false;
  users.extraUsers.elf = {
    isNormalUser = true;
    home = "/home/elf";
    description = "Elias Lawson-Fox";
    extraGroups = [
      "wheel"
      "systemd-journal"
      "wireshark"
      "dialout" # USB serial access for arduino
    ];
    uid = 1000;
    shell = pkgs.zsh;
    hashedPassword = credentials.users.elf;
  };
  users.extraUsers.root = {
    hashedPassword = credentials.users.root;
  };
  home-manager.users.elf = import ./elf { config = config; pkgs = pkgs; };
}
