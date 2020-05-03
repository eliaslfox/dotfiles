{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.features.wireguard;
  credentials = pkgs.callPackage ../credentials.nix { };
  wg = credentials.wireguard;
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
    systemd.services = {
      physical-netns = {
        description = "Network namespace for physical devices";
        wantedBy = [ "multi-user.target" ];
        before = [ "display-manager.service" "network.target" ];
        restartIfChanged = false;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.iproute}/bin/ip netns add physical";
          ExecStop = "${pkgs.iproute}/bin/ip netns delete physical";
        };
      };

      wg0 = {
        description = "Setup wireguard";
        after = [
          "physical-netns.service"
          "sys-subsystem-net-devices-${
            utils.escapeSystemdPath cfg.ethernetInterface
          }.device"
          "sys-subsystem-net-devices-${
            utils.escapeSystemdPath cfg.wirelessInterface
          }.device"
        ];
        requires = [
          "physical-netns.service"
          "sys-subsystem-net-devices-${
            utils.escapeSystemdPath cfg.ethernetInterface
          }.device"
          "sys-subsystem-net-devices-${
            utils.escapeSystemdPath cfg.wirelessInterface
          }.device"
        ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.iproute pkgs.wireguard pkgs.iw ];
        restartIfChanged = false;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "true";
          ExecStart = pkgs.writeScript "wg0-start" ''
            #!${pkgs.bash}/bin/bash
            ip -n physical link add wg0 type wireguard
            ip -n physical link set wg0 netns 1
            wg set wg0 private-key /root/wg/private peer ${wg.publickey} allowed-ips 0.0.0.0/0 endpoint ${wg.endpoint}
            ip link set wg0 up
            ip addr add ${wg.address} dev wg0
            ip route add default dev wg0

            ip link set ${cfg.ethernetInterface} netns physical
            iw phy phy0 set netns name physical
          '';
        };
      };

      wpa_supplicant-wg0 = {
        description = "Start wireless";
        after = [ "wg0.service" ];
        requires = [ "wg0.service" ];
        before = [ "network.target" ];
        wants = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.wpa_supplicant pkgs.iproute ];
        script =
          "ip netns exec physical wpa_supplicant -c${credentials.wpa_config} -i${cfg.wirelessInterface} -Dnl80211";
      };

      dhclient-wg0 = {
        description = "DHCP Client";
        after = [ "wg0.service" ];
        requires = [ "wg0.service" ];
        before = [ "network.target" ];
        wants = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.dhcp pkgs.iproute ];
        script = "ip netns exec physical dhclient -d ${cfg.wirelessInterface}";
        serviceConfig = { PartOf = "wpa_supplicant-wg0.service"; };
      };
    };

    powerManagement.resumeCommands = ''
      ${config.systemd.package}/bin/systemctl try-restart wpa_supplicant-wg0
    '';
  };
}
