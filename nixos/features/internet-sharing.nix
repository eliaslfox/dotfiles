{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;

  cfg = config.features.internet-sharing;
in {
  options.features.internet-sharing = {
    enable = mkEnableOption "internet sharing";

    externalInterface = mkOption {
      type = types.str;
      description = "The interface to forward traffic over";
      example = [ "wlan0" ];
    };

    internalInterface = mkOption {
      type = types.str;
      description = "The interface to forward traffic from";
      example = [ "eth0" ];
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      networking = {
        nat = {
          enable = true;
          externalInterface = cfg.externalInterface;
          internalInterfaces = [ cfg.internalInterface ];
        };

        interfaces."${cfg.internalInterface}".ipv4.addresses = [{
          address = "192.168.100.1";
          prefixLength = 24;
        }];
      };

      services.dhcpd4 = {
        enable = true;
        extraConfig = ''
          option subnet-mask 255.255.255.0;
          option broadcast-address 192.168.100.255;
          option routers 192.168.100.1;
          option domain-name-servers 8.8.8.8, 8.8.4.4;
          subnet 192.168.100.0 netmask 255.255.255.0 {
            range 192.168.100.100 192.168.100.200;
          }
        '';
        interfaces = [ cfg.internalInterface ];
      };
    })

    # Overrides to make internet sharing work with network namespaces
    (mkIf (config.features.wireguard.enable && cfg.enable) {

      systemd.services = {
        dhcpd4 = {
          after = lib.mkForce [ "physical-netns.service" ];
          requires = lib.mkForce [ "physical-netns.service" ];
          serviceConfig.NetworkNamespacePath = "/var/run/netns/physical";
        };

        "network-link-${config.features.internet-sharing.internalInterface}" = {
          after = lib.mkForce [ "physical-netns.service" ];
          requires = lib.mkForce [ "physical-netns.service" ];
          serviceConfig.NetworkNamespacePath = "/var/run/netns/physical";
          unitConfig.BindsTo = lib.mkForce [ ];
        };
        "network-addresses-${config.features.internet-sharing.internalInterface}" =
          {
            after = lib.mkForce [ "physical-netns.service" ];
            requires = lib.mkForce [ "physical-netns.service" ];
            serviceConfig.NetworkNamespacePath = "/var/run/netns/physical";
            unitConfig.BindsTo = lib.mkForce [ ];
          };
      };
    })
  ];
}
