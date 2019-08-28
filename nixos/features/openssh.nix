with import <nixpkgs> {};
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.openssh;
in
{
  options.features.openssh = {
    enable = mkEnableOption "enable ssh server";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      allowSFTP = false;
      challengeResponseAuthentication = false;
      passwordAuthentication = false;
      permitRootLogin = "no";
      openFirewall = false;
    };
  };
}
