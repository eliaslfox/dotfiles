with import <nixpkgs> {};
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.tor;
in
{
  options.features.tor = {
    enable = mkEnableOption "enable tor client";
  };

  config = mkIf cfg.enable {
    services.tor = {
      enable = true;
      client = {
        enable = true;
      };
    };
  };
}
