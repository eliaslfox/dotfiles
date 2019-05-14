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
    openssh.authorizedKeys.keys = [
     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC08t4eAEWYSpMLKstQnwHKuZ4VdmUY4c/NSC9vVMz6p5ymtgUEA58s6SrIIWeA6MkD5uQbn0Lmz0ijdkpQaDtKGBnp3o4MbKdrRQ9QG3uRKX6iXSEFkwfhRgU56yjqXcwgOUT8zD/KFPzfqAjXpg/8KU5a4DFFf1a7/tk4a/LE348FkHmq9BS2iD4qpo1eUsDWa9ETC0MJ+k0ViZedhyAN5Wly0319ps8m5Yw025UIIgeRemeT/+UZa5MveC0aI4m80iCB8gzGz2g7EwU9xt7uK8c4xEFmit0zuTP8wiUve/l0iCVkX1jAv37d47AGsFA/dDgNx8PX111ai32eZV1/ cardno:000606505626"
    ];
  };
  users.extraUsers.root = {
    passwordFile = "/etc/nixos/passwords/root";
    openssh.authorizedKeys.keys = [
     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC08t4eAEWYSpMLKstQnwHKuZ4VdmUY4c/NSC9vVMz6p5ymtgUEA58s6SrIIWeA6MkD5uQbn0Lmz0ijdkpQaDtKGBnp3o4MbKdrRQ9QG3uRKX6iXSEFkwfhRgU56yjqXcwgOUT8zD/KFPzfqAjXpg/8KU5a4DFFf1a7/tk4a/LE348FkHmq9BS2iD4qpo1eUsDWa9ETC0MJ+k0ViZedhyAN5Wly0319ps8m5Yw025UIIgeRemeT/+UZa5MveC0aI4m80iCB8gzGz2g7EwU9xt7uK8c4xEFmit0zuTP8wiUve/l0iCVkX1jAv37d47AGsFA/dDgNx8PX111ai32eZV1/ cardno:000606505626"
    ];
  };
  home-manager.users.elf = import ./elf { config = config; pkgs = pkgs; };
}
