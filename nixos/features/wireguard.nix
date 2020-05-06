{ config, lib, pkgs, utils, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.features.wireguard;
  credentials = pkgs.callPackage ../credentials.nix { };
  wg = credentials.wireguard;

  dhcpcdConf = pkgs.writeText "dhcpcd.conf" ''
    hostname

    option classless_staic_routes, interface_mtu

    nooption domain_name_servers, domain_name, domain_search, host_name, ntp_servers

    nohook lookup-hostname

    waitip
  '';
in {
  options.features.wireguard = {
    enable = mkEnableOption "wireguard vpn";
    ethernetInterface = mkOption {
      type = types.str;
      description = "The id of your ethernet interface";
      example = "eth0";
    };
    wirelessInterface = mkOption {
      type = types.str;
      description =
        "The id of your wireless interface. This is the only interface that will have dhcp enabled.";
      example = "wlan0";
    };
  };

  config = mkIf cfg.enable {
    networking.wireguard = {
      enable = true;

      interfaces."wg0" = {
        ips = [ credentials.wireguard.address ];
        privateKeyFile = "/root/wg/private";
        interfaceNamespace = "init";
        socketNamespace = "physical";

        peers = [{
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = credentials.wireguard.endpoint;
          publicKey = credentials.wireguard.publickey;
        }];
      };
    };

    systemd.services = {
      physical-netns = {
        description = "Network namespace for physical devices";
        after = [
          "sys-subsystem-net-devices-${cfg.ethernetInterface}.device"
          "sys-subsystem-net-devices-${cfg.wirelessInterface}.device"
        ];
        wantedBy = [ "multi-user.target" ];
        before = [ "network.target" ];
        wants = [ "network.target" ];
        restartIfChanged = false;
        path = [ pkgs.iproute pkgs.iw ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeScript "physical-netns-start" ''
            #!${pkgs.bash}/bin/bash
            set -eou pipefail

            ip netns add physical
            ip link set ${cfg.ethernetInterface} netns physical
            iw phy phy0 set netns name physical
          '';
        };
      };

      wireguard-wg0 = { after = [ "physical-netns.service" ]; };

      wpa_supplicant = {
        after = lib.mkForce [ "physical-netns.service" ];
        requires = lib.mkForce [ "physical-netns.service" ];
        serviceConfig = { NetworkNamespacePath = "/var/run/netns/physical"; };
      };

      dhcpcd = {
        after = lib.mkForce [ "physical-netns.service" ];
        requires = lib.mkForce [ "physical-netns.service" ];
        serviceConfig = {
          NetworkNamespacePath = "/var/run/netns/physical";
          ExecStart = lib.mkForce
            "@${pkgs.dhcpcd}/sbin/dhcpcd dhcpcd --quiet --config ${dhcpcdConf} wlp6s0";
          PIDFile = lib.mkForce "/run/dhcpcd-wlp6s0.pid";
        };
      };
    };
  };
}
