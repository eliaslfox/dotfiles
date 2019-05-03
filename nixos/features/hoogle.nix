{ config, lib, ... }:

with lib;

let
  cfg = config.features.hoogle;
in
{
  options.features.hoogle = {
    enable = mkEnableOption "config for hoogle";
  };

  config = mkIf cfg.enable {
    services = {
      hoogle = {
        enable = true;
        port = 1248;
        packages = hp: with hp;
           [ base
             text
             lens
             split
             optparse-generic
           ];
      };
      nginx = {
        enable = true;
        statusPage = true;
        virtualHosts = {
          "hoogle.owo" = {
            locations."/" = {
              proxyPass = "http://localhost:1248";
            };
          };
        };
      };
    };
    networking.hosts = {
      "127.0.0.1" = ["hoogle.owo"];
    };
  };
}
