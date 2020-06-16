{ pkgs, config, lib, ... }:
let credentials = pkgs.callPackage ../credentials.nix { };

in
{
  users.mutableUsers = false;
  users.extraUsers.elf = {
    isNormalUser = true;
    home = "/home/elf";
    description = "Elias Lawson-Fox";
    extraGroups = [
      "wheel"
      "video"
    ];
    uid = 1000;
    shell = pkgs.zsh;
    hashedPassword = credentials.users.elf;
  };
  users.extraUsers.root = { hashedPassword = credentials.users.root; };
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.elf = import ./elf {
      config = config;
      pkgs = pkgs;
      lib = lib;
    };
  };
}
